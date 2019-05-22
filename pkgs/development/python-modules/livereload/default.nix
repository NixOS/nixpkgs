{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, django
, tornado
, six
, pytest
}:

buildPythonPackage rec {
  pname = "livereload";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "python-livereload";
    rev = "v${version}";
    sha256 = "15v2a0af897ijnsfjh2r8f7l5zi5i2jdm6z0xzlyyvp9pxd6mpfm";
  };

  buildInputs = [ nose django ];

  propagatedBuildInputs = [ tornado six ];

  # Remove this patch when PR merged
  # https://github.com/lepture/python-livereload/pull/173
  postPatch = ''
   substituteInPlace tests/test_watcher.py \
     --replace 'watcher.watch(filepath, add_count)' \
               'add_count.repr_str = "add_count test task"; watcher.watch(filepath, add_count)'
  '';

  checkInputs = [ pytest ];
  checkPhase = "pytest tests";

  meta = {
    description = "Runs a local server that reloads as you develop";
    homepage = "https://github.com/lepture/python-livereload";
    license = lib.licenses.bsd3;
  };
}
