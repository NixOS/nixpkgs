#include <stdio.h>
#include <ctype.h>
#include <glib.h>
#include <string.h>
#include <locale.h>
#include <archive.h>
#include <archive_entry.h>

static char * case_normalize(char * str) {
  for (char * iter = str; *iter; ++iter) {
    *iter = tolower(*iter);
  }
  return str;
}

static gint compare_str(const void * a, const void * b, void * _) {
  return strcmp(a, b);
}

int main(int argc, char ** argv) {
  if (argc != 3) {
    fprintf(stderr, "Usage: %s TARBALL OUTPUT\n", argv[0]);
    return 1;
  }

  size_t output_len = strlen(argv[2]);

  /* Switch to standard locale to ensure consistency in case-folding.
   */
  setlocale(LC_CTYPE, "C");

  /* Map from case-normalized package name to a sorted sequence of
   * package names in the equivalence class defined by
   * case-normalization.
   */
  GHashTable * equivalence_classes =
    g_hash_table_new(g_str_hash, g_str_equal);

  /* Open up the tarball.
   */
  struct archive * ar = archive_read_new();
  if (!ar) {
    perror("Allocating archive structure");
    return 1;
  }
  archive_read_support_filter_gzip(ar);
  archive_read_support_format_tar(ar);
  if (archive_read_open_filename( ar
                                , argv[1]
                                , 10240
                                ) == ARCHIVE_FATAL) {
    fprintf( stderr
           , "Error opening %s: %s\n"
           , argv[0]
           , archive_error_string(ar)
           );
    return 1;
  }

  /* Extract the length of the output directory that prefixes all
   * tarball entries from the first entry in the tarball.
   */
  struct archive_entry * ent;
  int err = archive_read_next_header(ar, &ent);
  if (err != ARCHIVE_OK) {
    if (err == ARCHIVE_EOF) {
      fprintf( stderr
             , "No entries in %s, surely this is an error!\n"
             , argv[1]
             );
    } else {
      fprintf( stderr
             , "Error reading entry from %s: %s\n"
             , argv[1]
             , archive_error_string(ar)
             );
    }
    return 1;
  }
  const char * path = archive_entry_pathname(ent);
  /* Number of characters from the start of the path name until after
   * the slash after the leading directory.
   */
  size_t prefix_len = strchr(path, '/') - path + 1;

  /* Extract each entry to the right partition.
   */
  do {
    path = archive_entry_pathname(ent) + prefix_len;
    const char * pkg_end = strchr(path, '/');
    if (!pkg_end)
      /* If there is no second slash, then this is either just the entry
       * corresponding to the root or some non-package file (e.g.
       * travis.yml). In either case, we don't care.
       */
      continue;

    /* Find our package in the equivalence class map.
     */
    char * pkg_name = g_strndup(path, pkg_end - path);
    char * pkg_normalized =
      case_normalize(g_strndup(path, pkg_end - path));
    GSequence * pkg_class =
      g_hash_table_lookup(equivalence_classes, pkg_normalized);
    gint partition_num;
    if (!pkg_class) {
      /* We haven't seen any packages with this normalized name yet,
       * so we need to initialize the sequence and add it to the map.
       */
      pkg_class = g_sequence_new(NULL);
      g_sequence_append(pkg_class, pkg_name);
      g_hash_table_insert( equivalence_classes
                         , pkg_normalized
                         , pkg_class
                         );
      partition_num = 1;
    } else {
      g_free(pkg_normalized);
      /* Find the package name in the equivalence class */
      GSequenceIter * pkg_iter =
        g_sequence_search( pkg_class
                         , pkg_name
                         , compare_str
                         , NULL
                         );
      if (!g_sequence_iter_is_end(pkg_iter)) {
        /* If there are any packages after this one in the list, bail
         * out. In principle we could solve this by moving them up to
         * the next partition, but so far I've never seen any github
         * tarballs out of order so let's save ourselves the work
         * until we know we need it.
         */
        fprintf( stderr
               , "Out of order github tarball: %s is after %s\n"
               , pkg_name
               , (char *) g_sequence_get(pkg_iter)
               );
        return 1;
      }
      pkg_iter = g_sequence_iter_prev(pkg_iter);
      if (strcmp( g_sequence_get(pkg_iter)
                , pkg_name
                ) != 0) {
        /* This package doesn't have the same name as the one right
         * before where it should be in the sequence, which means it's
         * new and needs to be added to the sequence.
         *
         * !!! We need to change this to use g_sequence_insert_before
         * if we ever get an out-of-order github tarball, see comment
         * after the check for !g_sequence_iter_is_end(pkg_iter).
         */
        pkg_iter = g_sequence_append(pkg_class, pkg_name);
      } else {
        g_free(pkg_name);
      }
      /* Get the partition number, starting with 1.
       */
      partition_num = g_sequence_iter_get_position(pkg_iter) + 1;
    }

    /* Set the destination path.
     * The 3 below is for the length of /#/, the partition number part
     * of the path. If we have more than 9 partitions, we deserve to
     * segfault. The 1 at the end is for the trailing null.
     */
    char * dest_path = g_malloc(output_len + 3 + strlen(path) + 1);
    sprintf(dest_path, "%s/%d/%s", argv[2], partition_num, path);
    archive_entry_set_pathname(ent, dest_path);

    if (archive_read_extract(ar, ent, 0) != ARCHIVE_OK) {
      fprintf( stderr
             , "Error extracting entry %s from %s: %s\n"
             , dest_path
             , argv[1]
             , archive_error_string(ar)
             );
      return 1;
    }
  } while ((err = archive_read_next_header(ar, &ent)) == ARCHIVE_OK);
  if (err != ARCHIVE_EOF) {
    fprintf( stderr
           , "Error reading entry from %s: %s\n"
           , argv[1]
           , archive_error_string(ar)
           );
    return 1;
  }

  return 0;
}
