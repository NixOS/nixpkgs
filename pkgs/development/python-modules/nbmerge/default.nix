{ lib
, buildPythonPackage
, fetchFromGitHub
, nbformat
, nose
}:

buildPythonPackage rec {
  pname = "nbmerge";
  version = "unstable-2017-10-23";

  src = fetchFromGitHub {
    owner = "jbn";
    repo = pname;
    rev = "fc0ba95e8422340317358ffec4404235defbc06a";
    sha256 = "1cn550kjadnxc1sx2xy814248fpzrj3lgvrmsbrwmk03vwaa2hmi";
  };

  propagatedBuildInputs = [ nbformat ];
  nativeCheckInputs = [ nose ];

  checkPhase = ''
    patchShebangs .
    nosetests -v
    PATH=$PATH:$out/bin ./cli_tests.sh
  '';

  meta = {
    description = "A tool to merge/concatenate Jupyter (IPython) notebooks";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
