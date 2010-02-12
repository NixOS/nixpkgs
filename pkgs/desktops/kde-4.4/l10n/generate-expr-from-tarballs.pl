#! /usr/bin/perl -w

# Typical command to generate the list of tarballs:

# export i="mirror://kde/stable/4.4.0/src/kde-l10n/"; cat $(PRINT_PATH=1 nix-prefetch-url $i | tail -n 1) | perl -e 'while (<>) { if (/(href|HREF)="([^"]*.bz2)"/) { print "$ENV{'i'}$2\n"; }; }' | sort > tarballs.list
# manually update extra.list
# then run: cat tarballs-7.4.list extra.list old.list | perl ./generate-expr-from-tarballs.pl

use strict;

my $tmpDir = "/tmp/xorg-unpack";


my %pkgURLs;
my %pkgHashes;
my %pkgNames;

my $downloadCache = "./download-cache";
$ENV{'NIX_DOWNLOAD_CACHE'} = $downloadCache;
mkdir $downloadCache, 0755;

while (<>) {
    chomp;
    my $tarball = "$_";
    print "\nDOING TARBALL $tarball\n";

    $tarball =~ /\/((?:(?:[A-Za-z0-9_]|(?:-[^0-9])|(?:-[0-9]*[a-z]))+))[^\/]*$/;
    die unless defined $1;
    my $pkg = $1;
    $pkg =~ s/kde-l10n-//g;

    $tarball =~ /\/([^\/]*)\.tar\.bz2$/;
    my $pkgName = $pkg;

    print "  $pkg $pkgName\n";

    if (defined $pkgNames{$pkg}) {
	print "  SKIPPING\n";
	next;
    }

    $pkgNames{$pkg} = $pkgName;
    $pkgURLs{$pkg} = $tarball;

    my ($hash, $path) = `PRINT_PATH=1 QUIET=1 nix-prefetch-url '$tarball'`;
    chomp $hash;
    chomp $path;
    $pkgHashes{$pkg} = $hash;

    print "done\n";
}


print "\nWRITE OUT\n";

open OUT, ">default.nix";

print OUT "";
print OUT <<EOF;
# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-\${attr.lang}-4.4.0";
    src = fetchurl {
      url = attr.url;
      sha256 = attr.sha256;
    };
    buildInputs = [ cmake qt4 perl gettext kdelibs automoc4 phonon ];
    cmakeFlagsArray = [ "-DGETTEXT_INCLUDE_DIR=\${gettext}/include" ];
    meta = {
      description = "KDE l10n for \${attr.lang}";
      license = "GPL";
      homepage = http://www.kde.org;
    };
  };

in
{

EOF


foreach my $pkg (sort (keys %pkgNames)) {
    print "$pkg\n";
    
    print OUT <<EOF;
  $pkgNames{$pkg} = deriv {
    lang = "$pkgNames{$pkg}";
    url = "$pkgURLs{$pkg}";
    sha256 = "$pkgHashes{$pkg}";
  };

EOF
}

print OUT "}\n";

close OUT;
