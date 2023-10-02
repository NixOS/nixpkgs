{ lib
, buildPythonApplication
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, makeWrapper
, markdown-it-py
, poetry-core
, pytestCheckHook
, python3
, pythonOlder
, setuptools
, tomli
, typing-extensions
}:

let
  withPlugins = plugins: buildPythonApplication {
    pname = "${package.pname}";
    inherit (package) version;
    format = "other";

    disabled = pythonOlder "3.7";

    dontUnpack = true;
    dontBuild = true;
    doCheck = false;

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      makeWrapper ${package}/bin/mdformat $out/bin/mdformat \
        --prefix PYTHONPATH : "${package}/${python3.sitePackages}:$PYTHONPATH"
      ln -sfv ${package}/lib $out/lib
    '';

    propagatedBuildInputs = package.propagatedBuildInputs ++ plugins;

    passthru = package.passthru // {
      withPlugins = morePlugins: withPlugins (morePlugins ++ plugins);
    };

    meta.mainProgram = "mdformat";
  };

  package = buildPythonPackage rec {
    pname = "mdformat";
    version = "0.7.17";
    format = "pyproject";

    disabled = pythonOlder "3.7";

    src = fetchFromGitHub {
      owner = "executablebooks";
      repo = pname;
      rev = "refs/tags/${version}";
      hash = "sha256-umtfbhN6sDR/rFr1LwmJ21Ph9bK1Qq43bmMVzGCPD5s=";
    };

    nativeBuildInputs = [
      poetry-core
      setuptools
    ];

    propagatedBuildInputs = [
      markdown-it-py
      tomli
    ] ++ lib.optionals (pythonOlder "3.10") [
      importlib-metadata
    ] ++ lib.optionals (pythonOlder "3.7") [
      typing-extensions
    ];

    nativeCheckInputs = [
      pytestCheckHook
    ];

    disabledTests = [
      # AssertionError
      "test_no_codeblock_trailing_newline"
      # Issue with upper/lower case
      "default_style.md-options0"
    ];

    pythonImportsCheck = [
      "mdformat"
    ];

    passthru = { inherit withPlugins; };

    meta = with lib; {
      description = "CommonMark compliant Markdown formatter";
      homepage = "https://mdformat.rtfd.io/";
      changelog = "https://github.com/executablebooks/mdformat/blob/${version}/docs/users/changelog.md";
      license = with licenses; [ mit ];
      maintainers = with maintainers; [ fab aldoborrero ];
      mainProgram = "mdformat";
    };
  };
in
package
