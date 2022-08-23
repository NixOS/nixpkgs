{ lib
, buildPythonPackage
, fetchPypi
, jinja2
, mistune
, pygments
, setuptools
}:

buildPythonPackage rec {
  pname = "mrkd";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "456f8c1be99da268554b29c6b5383532e58119def5a65d85270bc6a0ecc26aaf";
  };

  propagatedBuildInputs = [ jinja2 mistune pygments setuptools ];

  pythonImportsCheck = [ "mrkd" ];

  meta = with lib; {
    description = "Write man pages using Markdown, and convert them to Roff or HTML";
    homepage = "https://github.com/refi64/mrkd";
    license = licenses.bsd2;
    broken = versionAtLeast mistune.version "2";
  };
}
