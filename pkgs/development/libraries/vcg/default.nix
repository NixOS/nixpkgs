{ lib, stdenv, fetchFromGitHub, eigen }:

stdenv.mkDerivation rec {
  pname = "vcg";
  version = "2023.12";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "vcglib";
    rev = version;
    sha256 = "sha256-U3pu1k2pCH+G4CtacaDQ9SgkFX5A9/O/qrdpgWvB1+U=";
  };

  propagatedBuildInputs = [ eigen ];

  installPhase = ''
    mkdir -p $out/include
    cp -r vcg wrap $out/include
    find $out -name \*.h -exec sed -i 's,<eigenlib/,<eigen3/,g' {} \;
  '';

  meta = with lib; {
    homepage = "https://vcg.isti.cnr.it/vcglib/install.html";
    description = "C++ library for manipulation, processing and displaying with OpenGL of triangle and tetrahedral meshes";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
