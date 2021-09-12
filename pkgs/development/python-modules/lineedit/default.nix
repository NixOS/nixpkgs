{ lib
, buildPythonPackage
, fetchFromGitHub
, pygments
, six
, wcwidth
}:

buildPythonPackage rec {
  pname = "lineedit";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    rev = "4262e9852aa50b09ff3f0569e1840b003ed00584";
    sha256 = "fq2NpjIQkIq1yzXEUxi6cz80kutVqcH6MqJXHtpTFsk=";
  };

  # Tests fail with "[Errno 1] Operation not permitted". This is
  # preceded by "Warning: Input is not to a terminal (fd=0)", so
  # probably related.
  doCheck = false;

  propagatedBuildInputs = [
    pygments
    six
    wcwidth
  ];

  pythonImportsCheck = [ "lineedit" ];

  meta = with lib; {
    description = "A readline library based on prompt_toolkit which supports multiple modes.";
    homepage = "https://github.com/randy3k/lineedit";
    license = licenses.mit;
    maintainers = with maintainers; [ jdreaver ];
  };
}
