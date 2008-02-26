#! /usr/bin/perl -w

use strict;

# Example use:
# ./make-listing.pl \
#   http://ftp.gnome.org/pub/GNOME/platform/2.10/2.10.1/sources/ \
#   http://ftp.gnome.org/pub/GNOME/platform/2.10/2.10.1/sources/MD5SUMS-for-bz2

my $baseURL = shift;
my $md5URL = shift;

print <<EOF
# Note: this file was generated automatically by make-listing.pl!

{fetchurl} : {
EOF
    ;
    
open FOO, "curl '$md5URL' |" or die;

while (<FOO>) {
    chomp;
    /^(\S+)\s+(\S+)$/ or die;
    my $md5 = $1;
    my $fileName = $2;
    my $name = $fileName;
    $name =~ s/\.tar.*$//;
    my $attrName = $name;
    $attrName =~ s/\-[0-9].*$//;
    $attrName =~ s/\-//g;
    $attrName =~ s/\+//g;
    print <<EOF
  $attrName = {
    name = "$name";
    src = fetchurl {
      url = $baseURL$fileName;
      md5 = "$md5";
    };
  };
EOF
    ;
    
}

close FOO;

print "}\n";
