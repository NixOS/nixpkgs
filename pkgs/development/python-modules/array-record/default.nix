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
  version = "0.8.1";
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
      platform = "manylinux2014_x86_64.manylinux_2_17_x86_64";
      hash =
        {
          cp311 = "sha256-CQ2ChYqTHjdU4QYvXGLCCudk8+XyTnnqkFQ5OAQ4Oo0=";
          cp312 = "sha256-AF+29PToM7LeHE5RxiCtajCok7RtwWgDnZuzG3FGYHA=";
          cp313 = "sha256-N7uALh/cmO22CoWVUsfn1JThQc85C/tzUKz9Y0Z9rq4=";
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
