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
  version = "0.7.1";
  format = "wheel";

  disabled = pythonOlder "3.10" || pythonAtLeast "3.13";

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
          cp310 = "sha256-JDaj1iJy1BQ7fHjmCbGQkNqG5rIRuwTwENbanM9a8hg=";
          cp311 = "sha256-QVynMK9t0BnEtgdfbJ5T3s7N02i0XD2siUSRxKtrI+M=";
          cp312 = "sha256-xJJGm6kLQ2/TzVYTrBtQ1Hqky1odHfbhe/g+PSSYt1c=";
        }
        .${pyShortVersion} or (throw "${pname} is missing hash for ${pyShortVersion}");
    };

  dependencies = [
    absl-py
    etils
  ] ++ etils.optional-dependencies.epath;

  pythonImportsCheck = [ "array_record" ];

  meta = {
    description = "ArrayRecord is a new file format derived from Riegeli, achieving a new frontier of IO efficiency";
    homepage = "https://github.com/google/array_record";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = [ "x86_64-linux" ];
  };
}
