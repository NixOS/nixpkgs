{ stdenv, fetchFromGitHub, eigen }:

stdenv.mkDerivation rec {
  name = "vcg-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "vcglib";
    rev = "v${version}";
    sha256 = "0jh8jc8rn7rci8qr3q03q574fk2hsc3rllysck41j8xkr3rmxz2f";
  };

  propagatedBuildInputs = [ eigen ];

  installPhase = ''
    mkdir -p $out/include
    cp -r vcg wrap $out/include
    find $out -name \*.h -exec sed -i 's,<eigenlib/,<eigen3/,g' {} \;
  '';

  meta = with stdenv.lib; {
    homepage = "http://vcg.isti.cnr.it/vcglib/install.html";
    description = "C++ library for manipulation, processing and displaying with OpenGL of triangle and tetrahedral meshes";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
