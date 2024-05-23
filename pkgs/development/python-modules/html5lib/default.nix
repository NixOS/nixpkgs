{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  six,
  webencodings,
  mock,
  pytest-expect,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "html5lib";
  version = "1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f";
  };

  patches = [
    # Fix compatibility with pytest 6.
    # Will be included in the next release after 1.1.
    (fetchpatch {
      url = "https://github.com/html5lib/html5lib-python/commit/2c19b9899ab3a3e8bd0ca35e5d78544334204169.patch";
      hash = "sha256-VGCeB6o2QO/skeCZs8XLPfgEYVOSRL8cCpG7ajbZWEs=";
    })
  ];

  propagatedBuildInputs = [
    six
    webencodings
  ];

  # latest release not compatible with pytest 6
  doCheck = false;
  nativeCheckInputs = [
    mock
    pytest-expect
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/html5lib/html5lib-python";
    downloadPage = "https://github.com/html5lib/html5lib-python/releases";
    description = "HTML parser based on WHAT-WG HTML5 specification";
    longDescription = ''
      html5lib is a pure-python library for parsing HTML. It is designed to
      conform to the WHATWG HTML specification, as is implemented by all
      major web browsers.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      domenkozar
      prikhi
    ];
  };
}
