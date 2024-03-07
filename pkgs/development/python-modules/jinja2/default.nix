{ lib
, stdenv
, python
, buildPythonPackage
, pythonOlder
, fetchPypi
, babel
, markupsafe
, pytestCheckHook
, sphinxHook
, pallets-sphinx-themes
, sphinxcontrib-log-cabinet
, sphinx-issues
}:

buildPythonPackage rec {
  pname = "Jinja2";
  version = "3.1.2";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MTUacCpAip51laj8YVD8P0O7a/fjGXcMvA2535Q36FI=";
  };

  propagatedBuildInputs = [
    babel
    markupsafe
  ];

  # Multiple tests run out of stack space on 32bit systems with python2.
  # See https://github.com/pallets/jinja/issues/1158
  doCheck = !stdenv.is32bit;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # Avoid failure due to deprecation warning
    # Fixed in https://github.com/python/cpython/pull/28153
    # Remove after cpython 3.9.8
    "-p no:warnings"
  ];

  passthru = {
    doc = stdenv.mkDerivation {
      # Forge look and feel of multi-output derivation as best as we can.
      #
      # Using 'outputs = [ "doc" ];' breaks a lot of assumptions.
      name = "${pname}-${version}-doc";
      inherit src pname version;

      patches = [
        # Fix import of "sphinxcontrib-log-cabinet"
        ./patches/import-order.patch
      ];

      postInstallSphinx = ''
        mv $out/share/doc/* $out/share/doc/python$pythonVersion-$pname-$version
      '';

      nativeBuildInputs = [
        sphinxHook
        sphinxcontrib-log-cabinet
        pallets-sphinx-themes
        sphinx-issues
      ];

      inherit (python) pythonVersion;
      inherit meta;
    };
  };

  meta = with lib; {
    homepage = "https://jinja.palletsprojects.com/";
    description = "Stand-alone template engine";
    license = licenses.bsd3;
    longDescription = ''
      Jinja is a fast, expressive, extensible templating engine. Special
      placeholders in the template allow writing code similar to Python
      syntax. Then the template is passed data to render the final document.
      an optional sandboxed environment.
    '';
    maintainers = with maintainers; [ pierron ];
  };
}
