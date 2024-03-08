{ lib
, stdenv
, fetchFromGitHub
, python
, cmake
, ninja
}:

let
  pyEnv = python.withPackages (ps: [ ps.setuptools ps.tomli ps.pip ps.setuptools ]);
in
stdenv.mkDerivation rec {
  pname = "lief";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "lief-project";
    repo = "LIEF";
    rev = version;
    sha256 = "sha256-lH4SqwPB2Jp/wUI2Cll67PQbHbwMqpNuLy/ei8roiHg=";
  };

  outputs = [ "out" "py" ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  # Not a propagatedBuildInput because only the $py output needs it; $out is
  # just the library itself (e.g. C/C++ headers).
  buildInputs = [
    python
  ];

  env.CXXFLAGS = toString (lib.optional stdenv.isDarwin [ "-faligned-allocation" "-fno-aligned-new" "-fvisibility=hidden" ]);

  postBuild = ''
    pushd ../api/python
    ${pyEnv.interpreter} setup.py build --parallel=$NIX_BUILD_CORES
    popd
  '';

  postInstall = ''
    pushd ../api/python
    ${pyEnv.interpreter} setup.py install --skip-build --root=/ --prefix=$py
    popd
  '';

  meta = with lib; {
    description = "Library to Instrument Executable Formats";
    homepage = "https://lief.quarkslab.com/";
    license = [ licenses.asl20 ];
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ lassulus genericnerdyusername ];
  };
}
