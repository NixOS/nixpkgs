{ lib
, buildPythonPackage
, fetchPypi
, meson
, ninja
, intreehooks
, pytoml
, pythonOlder
}:

# TODO: offer meson as a Python package so we have dist-info folder.

buildPythonPackage rec {
  pname = "mesonpep517";
  version = "0.1.9999994";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5bcca61024164c4a51d29e6921ea1f756d54197c8f052e4c66a2b8399aa9349";
  };

  nativeBuildInputs = [ intreehooks  ];

  propagatedBuildInputs = [ pytoml ];

  # postPatch = ''
  #   # Meson tries to detect ninja as well, so we should patch meson as well.
  #   substituteInPlace mesonpep517/buildapi.py \
  #     --replace "'meson'" "'${meson}/bin/meson'" \
  #     --replace "'ninja'" "'${ninja}/bin/ninja'"
  # '';

  propagatedNativeBuildInputs = [ meson ninja ];

  meta = {
    description = "Create pep517 compliant packages from the meson build system";
    homepage = "https://gitlab.com/thiblahute/mesonpep517";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.fridh ];
  };
}
