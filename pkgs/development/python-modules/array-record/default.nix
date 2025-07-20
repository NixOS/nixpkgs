{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  python,
  fetchPypi,
  absl-py,
  etils,
}:

buildPythonPackage rec {
  pname = "array-record";
  version = "0.7.2";
  format = "wheel";

  disabled = pythonOlder "3.10" || pythonAtLeast "3.14";

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
    in
    fetchPypi {
      inherit version format;
      pname = "array_record";
      dist = pyShortVersion;
      python = pyShortVersion;
      abi = pyShortVersion;
      platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
      hash =
        {
          cp310 = "sha256-UmMEehSqMqgLy1TcYoKUX/tG4Tf8UM2xgnuUrXOiHGo=";
          cp311 = "sha256-cUN9Ws8A1xIN/n+/oGfv3mGUfmlsojLS69iWRpA2meM=";
          cp312 = "sha256-S+cV0NhXXlOzSTr2ED1oUuk6U1gQA0ZXoGPaWxGp/ZQ=";
          cp313 = "sha256-C7UvwXV0/NXA5dhr7NbUCW/KeUWg5w5F18aN2oAUXAQ=";
        }
        .${pyShortVersion} or (throw "${pname} is missing hash for ${pyShortVersion}");
    };

  dependencies = [
    absl-py
    etils
  ]
  ++ etils.optional-dependencies.epath;

  pythonImportsCheck = [ "array_record" ];

  meta = {
    description = "New file format derived from Riegeli, achieving a new frontier of IO efficiency";
    homepage = "https://github.com/google/array_record";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = [ "x86_64-linux" ];
  };
}
