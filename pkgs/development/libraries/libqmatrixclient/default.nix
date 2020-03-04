{ stdenv, fetchFromGitHub, cmake
, qtbase, qtmultimedia }:

let
  generic = version: sha256: prefix: stdenv.mkDerivation {
    pname = "libqmatrixclient";
    inherit version;

    src = fetchFromGitHub {
      owner = "QMatrixClient";
      repo  = "libqmatrixclient";
      rev   = "${prefix}${version}";
      inherit sha256;
    };

    postPatch = ''
      sed -i -e '/example/Id' CMakeLists.txt
    '';

    buildInputs = [ qtbase qtmultimedia ];

    nativeBuildInputs = [ cmake ];

    meta = with stdenv.lib; {
      description= "A Qt5 library to write cross-platfrom clients for Matrix";
      homepage = https://matrix.org/docs/projects/sdk/libqmatrixclient.html;
      license = licenses.lgpl21;
      platforms = with platforms; linux ++ darwin;
      maintainers = with maintainers; [ peterhoeg ];
    };
  };

in rec {
  libqmatrixclient_0_4 = generic "0.4.2.1" "056hvp2m74wx72yd8vai18siddj9l8bhrvrkc4ia4cwjsqw02kid" "v";
  libqmatrixclient_0_5 = generic "0.5.2"   "1bhlqfs7251fss4icx794ka614npr6zyrpp4qwc4q5408ykfm7lr" "";

  libqmatrixclient = libqmatrixclient_0_4;
}
