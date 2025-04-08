{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "memory-tempfile";
  version = "2.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbello";
    repo = "memory-tempfile";
    rev = "v${version}";
    hash = "sha256-4fz2CLkZdy2e1GwGw/afG54LkUVJ4cza70jcbX3rVlQ=";
  };

  patches = [
    (fetchpatch2 {
      # Migrate to poetry-core build backend
      # https://github.com/mbello/memory-tempfile/pull/13
      name = "poetry-core.patch";
      url = "https://github.com/mbello/memory-tempfile/commit/938a3a3abf01756b1629eca6c69e970021bbc7c0.patch";
      hash = "sha256-q3027MwKXtX09MH7T2UrX19BImK1FJo+YxADfxcdTME=";
    })
  ];

  build-system = [ poetry-core ];

  doCheck = false; # constrained selection of memory backed filesystems due to build sandbox

  pythonImportsCheck = [ "memory_tempfile" ];

  meta = with lib; {
    description = "Create temporary files and temporary dirs in memory-based filesystems on Linux";
    homepage = "https://github.com/mbello/memory-tempfile";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
