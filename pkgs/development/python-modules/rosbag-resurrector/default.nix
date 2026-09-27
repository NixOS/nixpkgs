{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  duckdb,
  h5py,
  fastapi,
  numpy,
  mcap,
  mcap-ros2-support,
  pandas,
  plotly,
  polars,
  pyarrow,
  rich,
  typer,
  uvicorn,
  # tests
  httpx,
  pillow,
  psutil,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rosbag-resurrector";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vikramnagashoka";
    repo = "rosbag-resurrector";
    tag = "v${version}";
    hash = "sha256-gYt68wVFzIPuf2siIen6yNZIegOQHby90xTAZkA391k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    duckdb
    h5py
    fastapi
    numpy
    mcap
    mcap-ros2-support
    pandas
    plotly
    polars
    pyarrow
    rich
    typer
    uvicorn
  ];

  nativeCheckInputs = [
    httpx
    pillow
    psutil
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "resurrector" ];

  meta = {
    description = "Pandas-like analysis for robotics bag files with health checks, sync, ML export, semantic search, and WebSocket bridge.";
    homepage = "https://github.com/vikramnagashoka/rosbag-resurrector/";
    downloadPage = "https://github.com/vikramnagashoka/rosbag-resurrector/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
