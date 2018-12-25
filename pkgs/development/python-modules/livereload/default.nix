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
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "python-livereload";
    rev = "v${version}";
    sha256 = "0p3yvvr1iv3fv3pwc2qfzl3mi3b5zv6dh7kmfm1k7krxvganj87n";
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
