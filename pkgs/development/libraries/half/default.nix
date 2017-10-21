{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  version = "1.12.0";
  name = "half-${version}";

  src = fetchzip {
    url = "mirror://sourceforge/half/${version}/half-${version}.zip";
    sha256 = "0096xiw8nj86vxnn3lfcl94vk9qbi5i8lnydri9ws358ly6002vc";
    stripRoot = false;
  };

  buildCommand = ''
    mkdir -p $out/include $out/share/doc
    cp $src/include/half.hpp               $out/include/
    cp $src/{ChangeLog,LICENSE,README}.txt $out/share/doc/
  '';

  meta = with stdenv.lib; {
    description = "C++ library for half precision floating point arithmetics";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = [ maintainers.volth ];
  };
}
