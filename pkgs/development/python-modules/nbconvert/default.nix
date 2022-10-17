{ beautifulsoup4
, bleach
, buildPythonPackage
, defusedxml
, fetchPypi
, fetchpatch
, ipywidgets
, jinja2
, jupyterlab-pygments
, lib
, markupsafe
, mistune
, nbclient
, pandocfilters
, pyppeteer
, pytestCheckHook
, tinycss2
}:

buildPythonPackage rec {
  pname = "nbconvert";
  version = "6.5.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EO1pPEz9PGNYPIfKXDovbth0FFEDWV84JO/Mjfy3Uiw=";
  };

  # Add $out/share/jupyter to the list of paths that are used to search for
  # various exporter templates
  patches = [
    ./templates.patch

    # Use mistune 2.x
    (fetchpatch {
      name = "support-mistune-2.x.patch";
      url = "https://github.com/jupyter/nbconvert/commit/e870d9a4a61432a65bee5466c5fa80c9ee28966e.patch";
      hash = "sha256-kdOmE7BnkRy2lsNQ2OVrEXXZntJUPJ//b139kSsfKmI=";
      excludes = [ "pyproject.toml" ];
    })

    # patch nbconvert/filters/markdown_mistune.py
    (fetchpatch {
      name = "clean-up-markdown-parsing.patch";
      url = "https://github.com/jupyter/nbconvert/commit/4df1f5451c9c3e8121036dfbc7e07f0095f4d524.patch";
      hash = "sha256-O+VWUaQi8UMCpE9/h/IsrenmEuJ2ac/kBkUBq7GFJTY";
    })
    (fetchpatch {
      name = "fix-markdown-table.patch";
      url = "https://github.com/jupyter/nbconvert/commit/d3900ed4527f024138dc3a8658c6a1b1dfc43c09.patch";
      hash = "sha256-AFE1Zhw29JMLB0Sj17zHcOfy7VEFqLekO8NYbyMLrdI=";
    })
  ];

  postPatch = ''
    substituteAllInPlace ./nbconvert/exporters/templateexporter.py

    # Use mistune 2.x
    substituteInPlace setup.py \
        --replace "mistune>=0.8.1,<2" "mistune>=2.0.3,<3"

    # Equivalent of the upstream patch https://github.com/jupyter/nbconvert/commit/aec39288c9a6c614d659bcaf9f5cb36634d6b37b.patch
    substituteInPlace share/jupyter/nbconvert/templates/lab/base.html.j2 \
        --replace "{{ output.data['image/svg+xml'] | clean_html }}" "{{ output.data['image/svg+xml'].encode(\"utf-8\") | clean_html }}"
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    bleach
    defusedxml
    jinja2
    jupyterlab-pygments
    markupsafe
    mistune
    nbclient
    pandocfilters
    tinycss2
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkInputs = [
    ipywidgets
    pyppeteer
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # DeprecationWarning: Support for bleach <5 will be removed in a future version of nbconvert
    "-W ignore::DeprecationWarning"
  ];

  disabledTests = [
    # Attempts network access (Failed to establish a new connection: [Errno -3] Temporary failure in name resolution)
    "test_export"
    "test_webpdf_with_chromium"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Converting Jupyter Notebooks";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
