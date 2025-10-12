{
  lib,
  buildPythonPackage,
  fetchurl,
  setuptools-rust,
  hatchling,
  cargo,
  rustc,
  httpx,
  platformdirs,
  tqdm,
}:

buildPythonPackage {
  pname = "puccinialin";
  version = "0.1.5";
  format = "pyproject";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/a5/1a/27a2a9ee534555c3bdccd04cdc63db17066e0bd6817e8540283d1c0a87a5/puccinialin-0.1.5.tar.gz";
    hash = "sha256-u7ZkGmNX9wYWvSb8Ajeov23+GbKO/Qdn/yBYvzfD1gI=";
  };
  nativeBuildInputs = [
    setuptools-rust
    cargo
    rustc
    hatchling
  ];
  propagatedBuildInputs = [
    httpx
    platformdirs
    tqdm
  ];
  pythonImportsCheck = [ "puccinialin" ];
  meta = with lib; {
    description = "Install rust into a temporary directory for boostrapping a rust-based build backend";
    homepage = "https://github.com/messense/puccinialin-py";
    license = licenses.mit;
    maintainers = with maintainers; [ monk3yd ];
  };
}
