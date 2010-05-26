#!/bin/sh
libName=@libName@

# this is a quick and dirty implementation

do_help(){
  echo "$0 --str str in-file|- [out|-|psql:db]";
  echo "in: - = STDIN or filename";
  echo "out: - = STDIN or filename or psql:database_name" 
  echo "         psql:database_name will load the dump into the database" 
  echo "         if out is omitted in is used for out (same file)"
  echo "--str: different replacement string. Eg for Ubuntu use: '/usr/lib/postgresql/8.3/lib/liblwgeom'";
  echo "WARNING: A postgis dump is not meant to be distributed - it still may be useful :)"
}

if [ -z "$1" -o "$1" = --help -o "$1" = -h ]; then
  do_help; exit 1
fi

tostr='$libdir/'"$libName"
if [ "$1" == "--str" ]; then
  to="$2"; shift 2
fi

i=$1
o="${2:-$1}"

cmd_in(){
  case "$i" in
    -) cat;;
    *) cat "$i";;
  esac
}

cmd_out(){
  case "$o" in
    -) cat;;  # stdout
    psql:*) psql "${o:5}";; # pipe into psql
    *)
      t=`mktemp`; cat > "$t"; mv "$t" "$o"
      ;;
  esac
}

cmd_replace(){
  contents=`cat`
  # get wrong library path:
  fromstr=$(echo "$contents" | head -n 50 | sed -n "s/.*AS '\([^']*\)'.*/\1/p" | head -n 1)
  echo "$contents" | sed "s@AS '$fromstr@AS '$tostr@g"
}

cmd_in | cmd_replace | cmd_out
