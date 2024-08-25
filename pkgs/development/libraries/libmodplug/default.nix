{ lib, stdenv, fetchurl, file }:

stdenv.mkDerivation rec {
  pname = "libmodplug";
  version = "0.8.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/modplug-xmms/libmodplug/${version}/${pname}-${version}.tar.gz";
    sha256 = "1pnri98a603xk47smnxr551svbmgbzcw018mq1k6srbrq6kaaz25";
  };

  # Unfortunately, upstream appears inactive and the patches from the fork don’t apply cleanly.
  # Modify `src/fastmix.cpp` to remove usage of the register storage class, which is
  # not allowed in C++17 and is an error in clang 16.
  prePatch = "substituteInPlace src/fastmix.cpp --replace-fail 'register ' ''";

  outputs = [ "out" "dev" ];

  preConfigure = ''
     substituteInPlace configure \
        --replace-fail ' -mmacosx-version-min=10.5' "" \
        --replace-fail /usr/bin/file ${file}/bin/file
  '';

  meta = with lib; {
    description = "MOD playing library";
    homepage    = "https://modplug-xmms.sourceforge.net/";
    license     = licenses.publicDomain;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ raskin ];
  };
}
