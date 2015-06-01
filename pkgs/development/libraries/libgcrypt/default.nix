{ stdenv, fetchurl
, libgpgerror

# Optional Dependencies
, libcap ? null, pth ? null
}:

let
  mkFlag = trueStr: falseStr: cond: name: val:
    if cond == null then null else
      "--${if cond != false then trueStr else falseStr}${name}${if val != null && cond != false then "=${val}" else ""}";
  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "without-";
  mkOther = mkFlag "" "" true;

  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  optLibcap = shouldUsePkg libcap;
  #optPth = shouldUsePkg pth;
  optPth = null; # Broken as of 1.6.3
in
stdenv.mkDerivation rec {
  name = "libgcrypt-1.6.3";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "0pq2nwfqgggrsh8rk84659d80vfnlkbphwqjwahccd5fjdxr3d21";
  };

  buildInputs = [ libgpgerror optLibcap optPth ];

  configureFlags = [
    (mkWith   (optLibcap != null) "capabilities"  null)
    (mkEnable (optPth != null)    "random-daemon" null)
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
