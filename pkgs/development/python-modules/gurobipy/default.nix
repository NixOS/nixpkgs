{
  lib,
  stdenv,
  buildPythonPackage,
  python,
  fetchPypi,
}:

let
  format = "wheel";
  pyShortVersion = "cp" + builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  platforms = rec {
    aarch64-darwin = "macosx_10_9_universal2";
    aarch64-linux = "manylinux2014_aarch64.manylinux_2_17_aarch64";
    x86_64-darwin = aarch64-darwin;
    x86_64-linux = "manylinux2014_x86_64.manylinux_2_17_x86_64";
  };
  platform = platforms.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  hashes = rec {
    cp311-aarch64-darwin = "sha256-pMwq4TXvr0mrKxZppeW2MQE/KrplWWFGmjKRLKwbHCI=";
    cp311-aarch64-linux = "sha256-fxJSQUt+nk7JBGtkDi+qTl/js0hnWGZGyht4AqD9g60=";
    cp311-x86_64-darwin = cp311-aarch64-darwin;
    cp311-x86_64-linux = "sha256-q1nmuWmlDPeNWWw4bX3KECOChNQkwU+6hItYqWcyY4M=";
    cp312-aarch64-darwin = "sha256-5+1QxYOhjbs01S3gqhkQ9Bx/0/NhbXEi710BGpiC5kM=";
    cp312-aarch64-linux = "sha256-N7cFtibenj+SrZ7ZtevZtDUdW48DnLC4p5jB9vrWlb8=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-Aw5xxvCwdgfdT7HMrWT/jKWx3RDjs8IuB4in0ZGdqcw=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "11.0.1";
  inherit format;

  src = fetchPypi {
    inherit pname version;
    python = pyShortVersion;
    abi = pyShortVersion;
    dist = pyShortVersion;
    inherit format platform hash;
  };

  pythonImportsCheck = [ "gurobipy" ];

  meta = {
    description = "Python interface to Gurobi";
    homepage = "https://www.gurobi.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = builtins.attrNames platforms;
  };
}
