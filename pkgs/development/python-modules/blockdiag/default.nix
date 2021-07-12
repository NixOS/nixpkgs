{ lib, buildPythonPackage, fetchFromGitHub
, setuptools, funcparserlib, pillow, webcolors, reportlab, docutils
}:

buildPythonPackage rec {
  pname = "blockdiag";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = "blockdiag";
    rev = version;
    sha256 = "1cvcl66kf4wdh2n4fdk37zk59lp58wd2fhf84n7pbn0lilyksk5x";
  };

  propagatedBuildInputs = [ setuptools funcparserlib pillow webcolors reportlab docutils ];

  # require network and fail
  doCheck = false;

  meta = with lib; {
    description = "Generate block-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor SuperSandro2000 ];
  };
}
