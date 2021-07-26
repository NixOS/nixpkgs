{ lib, stdenv, buildPythonPackage, fetchPypi, autoPatchelfHook
, python, isPy38, isPy39, absl-py, attrs, matplotlib, numpy, opencv4, protobuf, six, wheel
, unzip, zip }:

buildPythonPackage rec {
  pname = "mediapipe";
  version = "0.8.6";
  format = "wheel";

  disabled = !(isPy38 || isPy39);

  pyInterpreterVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";

  src = fetchPypi ({
    inherit pname version format;
    python = pyInterpreterVersion;
    abi = pyInterpreterVersion;
  } // {
    "x86_64-linux"."cp38" = {
      platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
      sha256 = "0f79983453mdk16695n5wniqhx29gw7m49r0m4wvzh5glpq39dsz";
    };
    "x86_64-linux"."cp39" = {
      platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
      sha256 = "00dg3rw2j0n233pk878ncmdz5pvblj702dv3j4p0hvxf1inqwa3n";
    };
    "x86_64-darwin"."cp38" = {
      platform = "macosx_10_15_x86_64";
      sha256 = "00jhkhna1296y39p7dc3wkmv1v00ay8why7ay5q7drav0z8b7s00";
    };
    "x86_64-darwin"."cp39" = {
      platform = "macosx_10_15_x86_64";
      sha256 = "08g0m4x32a3k5y6ncpw31zff7axdkpnrziizib4jkqqwd3i41kxg";
    };
  }.${stdenv.system}.${pyInterpreterVersion});

  nativeBuildInputs = [ unzip zip autoPatchelfHook ];

  postPatch = ''
    # Patch out requirement for static opencv so we can substitute it with the nix version
    METADATA=mediapipe-${version}.dist-info/METADATA
    unzip $src $METADATA
    substituteInPlace $METADATA \
      --replace "Requires-Dist: opencv-contrib-python" ""
    chmod +w dist/*.whl
    zip -r dist/*.whl $METADATA
  '';

  propagatedBuildInputs = [
    absl-py
    attrs
    matplotlib
    numpy
    opencv4
    protobuf
    six
    wheel
  ];

  pythonImportsCheck = [ "mediapipe" ];

  meta = with lib; {
    description = "Cross-platform, customizable ML solutions for live and streaming media";
    homepage = "https://mediapipe.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
