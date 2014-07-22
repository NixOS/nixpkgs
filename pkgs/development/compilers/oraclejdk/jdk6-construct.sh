#!/bin/bash
# construct.sh
# example construction of JRE and JDK directories from the DLJ bundles
#
# Copyright © 2006 Sun Microsystems, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Sun, Sun Microsystems, the Sun logo and Java, Java HotSpot,
# and JVM  trademarks or registered trademarks of Sun Microsystems,
# Inc. in the U.S. and other countries.


program=`basename $0`

usage () {
  echo "usage: ${program} path/to/unbundle-jdk path/to/linux-jdk path/to/linux-jre"
}

getargs() {
  undir=$1
  jdkdir=$2
  jredir=$3
  if [ ! -d $undir ]; then
    echo "${program}: unbundle directory not found: $undir"
    exit 2
  fi
  # make sure javahome is the JDK
  javahome=`echo $undir/*/db/demo`
  if [ ! -d $javahome ]; then
    echo "${program}: unbundle directory incorrect: $undir"
    echo "  expecting $undir/jdk1.5.0_xx"
    exit 2
  else
    javahome=$(dirname $(dirname $javahome))
  fi
  # verify JDK dir
  jdkdirp=`dirname $jdkdir`
  jdkbase=`basename $jdkdir`
  if [ ! -d $jdkdirp ]; then
    echo "${program}: parent directory for JDK does not exist: $jdkdirp"
    exit 2
  fi
  savedir=`pwd`
  cd $jdkdirp
  jdkdirp=`pwd`
  cd $savedir
  jdkdir=$jdkdirp/$jdkbase
  # verify JRE dir
  jredirp=`dirname $jredir`
  jrebase=`basename $jredir`
  if [ ! -d $jredirp ]; then
    echo "${program}: parent directory for JRE does not exist: $jredirp"
    exit 2
  fi
  savedir=`pwd`
  cd $jredirp
  jredirp=`pwd`
  cd $savedir
  jredir=$jredirp/$jrebase
}

checkfiles() {
  if [ -r $jdkdir ]; then
    echo "${program}: directory for JDK already exists: $jdkdir"
    exit 2
  fi
  if [ -r $jredir ]; then
    echo "${program}: directory for JRE already exists: $jredir"
    exit 2
  fi
}

copytree() {
  echo "copying over the JDK tree..."
  cp -a $javahome $jdkdir
}

linkrel() {
  target=$1
  link=$2
  # make a softlink from the $link to the $target
  # make this a relative link
  targetb=(`echo $target | tr '/' ' '`)
  linkb=(`echo $link | tr '/' ' '`)
  (( n = ${#targetb[*]} ))
  (( m = ${#linkb[*]} ))
  c=$n  # common length
  if [ $m -lt $c ]; then
    (( c = m ))
  fi
  for (( i = 0 ; i < c ; i++ )); do
    if [ ${targetb[$i]} != ${linkb[$i]} ]; then
      # echo components differ, stopping
      break
    fi
  done
  rel=""
  for (( j = i + 1; j < m ; j++ )); do
    if [ -z $rel ]; then
      rel=".."
    else
      rel="$rel/.."
    fi
  done
  for (( j = i; j < n ; j++ )); do
    if [ -z $rel ]; then
      rel=${targetb[$j]}
    else
      rel="$rel/${targetb[$j]}"
    fi
  done
  ln -s $rel $link
}

createjre() {
  echo "creating JRE directory..."
  # absolute link
  # ln -s $jdkdir/jre $jredir
  # relative link
  linkrel $jdkdir/jre $jredir
}

unpackjars() {
  echo "unpacking jars..."
  unpack200=$jdkdir/bin/unpack200
  if [ ! -x $unpack200 ]; then
    echo "${program}: file missing $unpack200"
    exit 1
  fi
  cd $jdkdir
  PACKED_JARS=`find . -name '*.pack'`
  for i in $PACKED_JARS; do
    # echo $i
    jdir=`dirname $i`
    jbase=`basename $i .pack`
    if ! $unpack200 $jdkdir/$jdir/$jbase.pack $jdkdir/$jdir/$jbase.jar; then
      echo "${program}: error unpacking $jdkdir/$jdir/$jbase.jar"
    fi
    if [ ! -r $jdkdir/$jdir/$jbase.jar ]; then
      echo "${program}: missing $jdkdir/$jdir/$jbase.jar"
    else
      echo "  $jdir/$jbase.jar"
      # remove pack file
      rm $jdkdir/$jdir/$jbase.pack
    fi
  done
}

preparecds() {
  # if this is a client installation...
  compiler="`$jdkdir/bin/java -client -version 2>&1 | tail -n +3 | cut -d' ' -f1-4`"
  if [ "X$compiler" = "XJava HotSpot(TM) Client VM" ]; then
    # create the CDS archive
    echo "creating the class data sharing archive..."
    if ! $jdkdir/bin/java -client -Xshare:dump > /dev/null 2>&1; then
       echo "returned error code $?"
    fi
  fi
}

jreman () {
  echo "setting up the JRE man pages..."
  # note this list is slightly different for OpenSolaris bundles
  jreman=/tmp/jre.man.txt
cat <<EOF > $jreman
man/ja_JP.eucJP/man1/java.1
man/ja_JP.eucJP/man1/javaws.1
man/ja_JP.eucJP/man1/keytool.1
man/ja_JP.eucJP/man1/orbd.1
man/ja_JP.eucJP/man1/pack200.1
man/ja_JP.eucJP/man1/policytool.1
man/ja_JP.eucJP/man1/rmid.1
man/ja_JP.eucJP/man1/rmiregistry.1
man/ja_JP.eucJP/man1/servertool.1
man/ja_JP.eucJP/man1/tnameserv.1
man/ja_JP.eucJP/man1/unpack200.1
man/man1/java.1
man/man1/javaws.1
man/man1/keytool.1
man/man1/orbd.1
man/man1/pack200.1
man/man1/policytool.1
man/man1/rmid.1
man/man1/rmiregistry.1
man/man1/servertool.1
man/man1/tnameserv.1
man/man1/unpack200.1
EOF
  # create jre/man directory
  # mkdir $jdkdir/jre/man
  # move the real JRE man pages to jre/man
  # link the JDK JRE man pages to jre/man
  # real JDK man pages stay where they are
  for m in `cat $jreman`; do
    manpath=`dirname $jdkdir/jre/$m`
    mkdir -p $manpath
    mv $jdkdir/$m $jdkdir/jre/$m
    linkrel $jdkdir/jre/$m $jdkdir/$m
  done
  # link in Japanese man pages
  ln -s ja_JP.eucJP $jdkdir/jre/man/ja
  rm $jreman
}

elimdups() {
  echo "eliminating duplication between the JDK and JDK/jre..."
  jdkcomm=/tmp/jdk.bin.comm.txt
cat <<EOF > $jdkcomm
bin/ControlPanel
bin/java
bin/javaws
bin/keytool
bin/orbd
bin/pack200
bin/policytool
bin/rmid
bin/rmiregistry
bin/servertool
bin/tnameserv
bin/unpack200
EOF
  # note there is little point in linking these common files
  #   COPYRIGHT
  #   LICENSE
  #   THIRDPARTYLICENSEREADME.txt
  # And this file is unique to the JDK
  #   README.html
  # And these files are unique to the JDK/jre/
  #   CHANGES
  #   README
  #   Welcome.html
  for p in `cat $jdkcomm`; do
    rm $jdkdir/$p
    # this is a relative link
    ln -s ../jre/$p $jdkdir/$p
  done
  rm $jdkcomm
}

if [ $# -eq 3 ] ; then
  getargs $1 $2 $3
  checkfiles
  copytree
  createjre
  unpackjars
  preparecds
  jreman
  elimdups
else
  usage
  exit 1
fi

exit 0

