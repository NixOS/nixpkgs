{ lib
, buildPythonPackage
, fetchFromGitHub
, installShellFiles
, mock
, scripttest
, setuptools
, virtualenv
, wheel
, pretend
, pytest

# docs
, sphinx

# coupled downsteam dependencies
, pip-tools
}:

buildPythonPackage rec {
  pname = "pip";
  version = "23.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-mUlzfYmq1FE3X1/2o7sYJzMgwHRI4ib4EMhpg83VvrI=";
  };

  postPatch = ''
    # Remove vendored Windows PE binaries
    # Note: These are unused but make the package unreproducible.
    find -type f -name '*.exe' -delete
  '';

  nativeBuildInputs = [
    installShellFiles
    setuptools
    wheel

    # docs
    sphinx
  ];

  outputs = [
    "out"
    "man"
  ];

  # pip uses a custom sphinx extension and unusual conf.py location, mimic the internal build rather than attempting
  # to fit sphinxHook see https://github.com/pypa/pip/blob/0778c1c153da7da457b56df55fb77cbba08dfb0c/noxfile.py#L129-L148
  postBuild = ''
    cd docs

    # remove references to sphinx extentions only required for html doc generation
    # sphinx.ext.intersphinx requires network connection or packaged object.inv files for python and pypug
    # sphinxcontrib.towncrier is not currently packaged
    for ext in sphinx.ext.intersphinx sphinx_copybutton sphinx_inline_tabs sphinxcontrib.towncrier myst_parser; do
      substituteInPlace html/conf.py --replace '"'$ext'",' ""
    done

    PYTHONPATH=$src/src:$PYTHONPATH sphinx-build -v \
      -d build/doctrees/man \
      -c html \
      -d build/doctrees/man \
      -b man \
      man \
      build/man
    cd ..
  '';

  nativeCheckInputs = [ mock scripttest virtualenv pretend pytest ];

  # Pip wants pytest, but tests are not distributed
  doCheck = false;

  postInstall = ''
    installManPage docs/build/man/*

    installShellCompletion --cmd pip \
      --bash <($out/bin/pip completion --bash --no-cache-dir) \
      --fish <($out/bin/pip completion --fish --no-cache-dir) \
      --zsh <($out/bin/pip completion --zsh --no-cache-dir)
  '';

  passthru.tests = { inherit pip-tools; };

  meta = {
    description = "The PyPA recommended tool for installing Python packages";
    license = with lib.licenses; [ mit ];
    homepage = "https://pip.pypa.io/";
    changelog = "https://pip.pypa.io/en/stable/news/#v${lib.replaceStrings [ "." ] [ "-" ] version}";
  };
}
