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
, setuptools
, sphinxcontrib-log-cabinet
, sphinx-issues
}:

buildPythonPackage rec {
  pname = "jinja2";
  version = "3.1.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Jinja2";
    inherit version;
    hash = "sha256-rIvWVE1Lssl5K/OhWegLuo/afwfoG8Ou1WVDLVklupA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    markupsafe
  ];

  passthru.optional-dependencies = {
    i18n = [
      babel
    ];
  };

  # Multiple tests run out of stack space on 32bit systems with python2.
  # See https://github.com/pallets/jinja/issues/1158
  doCheck = !stdenv.is32bit;

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.i18n;

  passthru.doc = stdenv.mkDerivation {
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

  meta = with lib; {
    changelog = "https://github.com/pallets/jinja/blob/${version}/CHANGES.rst";
    description = "Very fast and expressive template engine";
    downloadPage = "https://github.com/pallets/jinja";
    homepage = "https://jinja.palletsprojects.com";
    license = licenses.bsd3;
    longDescription = ''
      Jinja is a fast, expressive, extensible templating engine. Special
      placeholders in the template allow writing code similar to Python
      syntax. Then the template is passed data to render the final document.
    '';
    maintainers = with maintainers; [ pierron ];
  };
}
