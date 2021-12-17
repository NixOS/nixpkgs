{ stdenv, lib, buildPythonPackage, fetchFromGitHub, python, pkg-config, pango, cython, AppKit, pytestCheckHook }:

buildPythonPackage rec {
  pname = "manimpango";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ManimCommunity";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qffb04bz4s2anb6a7nm6dpqwdlvq6626z1whqwrwsvn8z9sry76";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "--cov --no-cov-on-fail" ""
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pango ] ++ lib.optionals stdenv.isDarwin [ AppKit ];
  propagatedBuildInputs = [
    cython
  ];

  preBuild = ''
    ${python.interpreter} setup.py build_ext --inplace
  '';

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "manimpango" ];

  meta = with lib; {
    homepage = "https://github.com/ManimCommunity/ManimPango";
    license = licenses.gpl3Plus;
    description = "Binding for Pango";
    maintainers = [ maintainers.angustrau ];
  };
}
