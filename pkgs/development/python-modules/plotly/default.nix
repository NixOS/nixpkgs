{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  tenacity,
  kaleido,
  pytestCheckHook,
  pandas,
  requests,
  matplotlib,
  xarray,
  pillow,
  scipy,
  psutil,
  statsmodels,
  ipython,
  ipywidgets,
  which,
  orca,
  nbformat,
  scikit-image,
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "5.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-frSUybQxst4wG8g8U43Nay9dYCUXuR3dBealwPVyFdI=";
  };

  sourceRoot = "${src.name}/packages/python/plotly";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "\"jupyterlab~=3.0;python_version>='3.6'\"," ""
  '';

  env.SKIP_NPM = true;

  build-system = [ setuptools ];

  dependencies = [
    packaging
    tenacity
    kaleido
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    requests
    matplotlib
    xarray
    pillow
    scipy
    psutil
    statsmodels
    ipython
    ipywidgets
    which
    orca
    nbformat
    scikit-image
  ];

  disabledTests = [
    # FAILED plotly/matplotlylib/mplexporter/tests/test_basic.py::test_legend_dots - AssertionError: assert '3' == '2'
    "test_legend_dots"
    # FAILED plotly/matplotlylib/mplexporter/tests/test_utils.py::test_linestyle - AssertionError:
    "test_linestyle"
    # FAILED plotly/tests/test_io/test_to_from_plotly_json.py::test_sanitize_json[auto] - KeyError: 'template'
    # FAILED plotly/tests/test_io/test_to_from_plotly_json.py::test_sanitize_json[json] - KeyError: 'template'
    "test_sanitize_json"
    # FAILED plotly/tests/test_orca/test_orca_server.py::test_validate_orca - ValueError:
    "test_validate_orca"
    # FAILED plotly/tests/test_orca/test_orca_server.py::test_orca_executable_path - ValueError:
    "test_orca_executable_path"
    # FAILED plotly/tests/test_orca/test_orca_server.py::test_orca_version_number - ValueError:
    "test_orca_version_number"
    # FAILED plotly/tests/test_orca/test_orca_server.py::test_ensure_orca_ping_and_proc - ValueError:
    "test_ensure_orca_ping_and_proc"
    # FAILED plotly/tests/test_orca/test_orca_server.py::test_server_timeout_shutdown - ValueError:
    "test_server_timeout_shutdown"
    # FAILED plotly/tests/test_orca/test_orca_server.py::test_external_server_url - ValueError:
    "test_external_server_url"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_simple_to_image[eps] - ValueError:
    "test_simple_to_image"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_to_image_default[eps] - ValueError:
    "test_to_image_default"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_write_image_string[eps] - ValueError:
    "test_write_image_string"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_write_image_writeable[eps] - ValueError:
    "test_write_image_writeable"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_write_image_string_format_inference[eps] - ValueError:
    "test_write_image_string_format_inference"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_write_image_string_bad_extension_failure - assert 'must be specified as one of the followi...
    "test_write_image_string_bad_extension_failure"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_write_image_string_bad_extension_override - ValueError:
    "test_write_image_string_bad_extension_override"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_topojson_fig_to_image[eps] - ValueError:
    "test_topojson_fig_to_image"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_latex_fig_to_image[eps] - ValueError:
    "test_latex_fig_to_image"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_problematic_environment_variables[eps] - ValueError:
    "test_problematic_environment_variables"
    # FAILED plotly/tests/test_orca/test_to_image.py::test_invalid_figure_json - assert 'Invalid' in "\nThe orca executable is required in order to e...
    "test_invalid_figure_json"
    # FAILED test_init/test_dependencies_not_imported.py::test_dependencies_not_imported - AssertionError: assert 'plotly' not in {'IPython': <module>
    "test_dependencies_not_imported"
    # FAILED test_init/test_lazy_imports.py::test_lazy_imports - AssertionError: assert 'plotly' not in {'IPython': <module 'IPython' from '...
    "test_lazy_imports"
  ];

  pythonImportsCheck = [ "plotly" ];

  meta = {
    description = "Python plotting library for collaborative, interactive, publication-quality graphs";
    homepage = "https://plot.ly/python/";
    downloadPage = "https://github.com/plotly/plotly.py";
    changelog = "https://github.com/plotly/plotly.py/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
