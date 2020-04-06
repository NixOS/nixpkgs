{ stdenv, fetchgit, boost, gtk2, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  pname = "raul";
  version = "unstable-2019-12-09";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://gitlab.com/drobilla/raul.git";
    fetchSubmodules = true;
    rev = "e87bb398f025912fb989a09f1450b838b251aea1";
    sha256 = "1z37jb6ghc13b8nv8a8hcg669gl8vh4ni9djvfgga9vcz8rmcg8l";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ boost gtk2 python ];

  meta = with stdenv.lib; {
    description = "A C++ utility library primarily aimed at audio/musical applications";
    homepage = http://drobilla.net/software/raul;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
