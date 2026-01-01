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
<<<<<<< HEAD
  version = "0.8.3";
  format = "wheel";

  disabled = pythonOlder "3.11" || pythonAtLeast "3.15";
=======
  version = "0.8.1";
  format = "wheel";

  disabled = pythonOlder "3.10" || pythonAtLeast "3.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
          cp311 = "sha256-9ABPzOt5YaLMAJACjmij7rkdP1s4wA1gtTP3AE0dP3s=";
          cp312 = "sha256-RY9mWN6GyTabI//mTcsxOTqRm5GuLxUUfuK+sgELEio=";
          cp313 = "sha256-E98a7Js4r+mJc79f489SP4PKkEsEI9hTGZMIdxRbjyg=";
          cp314 = "sha256-idLPX0cJvjxsKzDA02YAUiM3VjP/zmbcsT2SegvcUig=";
=======
          cp311 = "sha256-CQ2ChYqTHjdU4QYvXGLCCudk8+XyTnnqkFQ5OAQ4Oo0=";
          cp312 = "sha256-AF+29PToM7LeHE5RxiCtajCok7RtwWgDnZuzG3FGYHA=";
          cp313 = "sha256-N7uALh/cmO22CoWVUsfn1JThQc85C/tzUKz9Y0Z9rq4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
