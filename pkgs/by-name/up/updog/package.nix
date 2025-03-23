{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "updog";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7n/ddjF6eJklo+T79+/zBxSHryebc2W9gxwxsb2BbF4=";
  };

  propagatedBuildInputs = with python3Packages; [
    colorama
    flask
    flask-httpauth
    werkzeug
    pyopenssl
  ];

  checkPhase = ''
    $out/bin/updog --help > /dev/null
  '';

  meta = with lib; {
    description = "Updog is a replacement for Python's SimpleHTTPServer";
    mainProgram = "updog";
    homepage = "https://github.com/sc0tfree/updog";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
  };
}
