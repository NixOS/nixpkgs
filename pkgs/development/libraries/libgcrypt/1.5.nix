{ stdenv, fetchurl
, libgpgerror

# Optional Dependencies
, libcap ? null
}:

let
  mkFlag = trueStr: falseStr: cond: name: val:
    if cond == null then null else
      "--${if cond != false then trueStr else falseStr}${name}${if val != null && cond != false then "=${val}" else ""}";
  mkWith = mkFlag "with-" "without-";

  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  optLibcap = shouldUsePkg libcap;
in
stdenv.mkDerivation rec {
  name = "libgcrypt-1.5.4";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "0czvqxkzd5y872ipy6s010ifwdwv29sqbnqc4pf56sd486gqvy6m";
  };

  buildInputs = [ libgpgerror optLibcap ];

  configureFlags = [
    (mkWith   (optLibcap != null) "capabilities"  null)
  ];

  # Make sure libraries are correct for .pc and .la files
  # Also make sure includes are fixed for callers who don't use libgpgcrypt-config
  postInstall = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror}/include/gpg-error.h",g' $out/include/gcrypt.h
  '' + stdenv.lib.optionalString (!stdenv.isDarwin && optLibcap != null) ''
    sed -i 's,\(-lcap\),-L${optLibcap}/lib \1,' $out/lib/libgcrypt.la
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/libgcrypt/;
    description = "General-pupose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
    repositories.git = git://git.gnupg.org/libgcrypt.git;
  };
}
