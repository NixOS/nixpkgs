{ lib
, stdenv
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
, enableDocumentation ? true
}:

buildPythonPackage rec {
  pname = "Jinja2";
  version = "3.1.2";
  outputs = [ "out" ] ++ lib.optional enableDocumentation "doc";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MTUacCpAip51laj8YVD8P0O7a/fjGXcMvA2535Q36FI=";
  };

  patches = lib.optionals enableDocumentation [ ./patches/import-order.patch ];

  propagatedBuildInputs = [
    babel
    markupsafe
  ];

  nativeBuildInputs = lib.optionals enableDocumentation [
    sphinxHook
    sphinxcontrib-log-cabinet
    pallets-sphinx-themes
    sphinx-issues
  ];

  # sphinx brings version of jinja2 with "enableDocumentation = false", so pip
  # deduces it has nothing to do, jinja2 is already installed, so $out ends up
  # without any python files.
  #
  # I can't use --force-uninstall, since then pip will try to uninstall jinja2
  # coming from sphinx, and will get permission denied. I found no way to hide
  # that other jinja2 from pip other than manipulate PYTHONPATH.
  preInstall = lib.optionalString enableDocumentation ''
    _saved_PYTHONPATH=$PYTHONPATH
    PYTHONPATH=$(echo $PYTHONPATH | tr ':' '\n'| grep -iv jinja2 | tr '\n' ':')
  '';

  postInstall = lib.optionalString enableDocumentation ''
    PYTHONPATH=$_saved_PYTHONPATH
  '';

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
