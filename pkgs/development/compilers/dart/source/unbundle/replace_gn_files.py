#!/usr/bin/env python3
# Copyright 2016 The Chromium Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""
Replaces GN files in tree with files from here that
make the build use system libraries.
"""

import argparse
import os
import shutil
import sys


REPLACEMENTS = {
  'icu': 'third_party/icu/BUILD.gn',
  'protobuf': 'build/secondary/third_party/protobuf/BUILD.gn',
  'zlib': 'third_party/zlib/BUILD.gn',
}


def DoMain(argv):
  my_dirname = os.path.dirname(__file__)
  source_tree_root = os.path.abspath(
    os.path.join(my_dirname, '..', '..', '..'))

  parser = argparse.ArgumentParser()
  parser.add_argument('--system-libraries', nargs='*', default=[])
  parser.add_argument('--undo', action='store_true')

  args = parser.parse_args(argv)

  handled_libraries = set()
  for lib, path in REPLACEMENTS.items():
    if lib not in args.system_libraries:
      continue
    handled_libraries.add(lib)

    if args.undo:
      # Restore original file, and also remove the backup.
      # This is meant to restore the source tree to its original state.
      os.rename(os.path.join(source_tree_root, path + '.orig'),
                os.path.join(source_tree_root, path))
    else:
      # Create a backup copy for --undo.
      shutil.copyfile(os.path.join(source_tree_root, path),
                      os.path.join(source_tree_root, path + '.orig'))

      # Copy the GN file from directory of this script to target path.
      shutil.copyfile(os.path.join(my_dirname, '%s.gn' % lib),
                      os.path.join(source_tree_root, path))

  unhandled_libraries = set(args.system_libraries) - handled_libraries
  if unhandled_libraries:
    print('Unrecognized system libraries requested: %s' % ', '.join(
        sorted(unhandled_libraries)), file=sys.stderr)
    return 1

  return 0


if __name__ == '__main__':
  sys.exit(DoMain(sys.argv[1:]))
