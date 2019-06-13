{ lib, python3Packages, }:

python3Packages.buildPythonApplication rec {
  pname = "addic7ed-cli";
  version = "1.4.5";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "16nmyw7j2igx5dxflwiwblf421g69rxb879n1553wv6hxi4x27in";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    pyquery
  ];

  meta = with lib; {
    description = "A commandline access to addic7ed subtitles";
    homepage = https://github.com/BenoitZugmeyer/addic7ed-cli;
    license = licenses.mit;
    maintainers = with maintainers; [ aethelz ];
    platforms = platforms.unix;
  };
}
