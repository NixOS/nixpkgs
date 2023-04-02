{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, grpcio-tools
, ujson
, grpcio
, pandas
, mmh3
, setuptools-scm
}:
buildPythonPackage rec {
  pname = "pymilvus";
  version = "2.2.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gj+psVoS6vcM4bNWzpwvKJJETTeCmZe6RwlzDkcvWo8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "grpcio-tools>=1.47.0, <=1.48.0" "grpcio-tools>=1.47.0, <=1.52.0" \
      --replace "grpcio>=1.47.0,<=1.48.0" "grpcio>=1.47.0,<=1.53.0" \
      --replace "ujson>=2.0.0,<=5.4.0" "ujson>=2.0.0,<=5.7.0"
    '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    grpcio
    grpcio-tools
    ujson
    pandas
    mmh3
  ] ++ lib.optionals stdenv.isLinux [ setuptools-scm ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/milvus-io/pymilvus";
    description = "Python SDK for Milvus. ";
    license = licenses.mit;
    maintainers = with maintainers; [happysalada];
  };
}
