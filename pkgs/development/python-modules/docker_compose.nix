{ stdenv, buildPythonApplication, fetchurl, pythonOlder
, mock, pytest, nose
, pyyaml, backports_ssl_match_hostname, colorama, docopt
, dockerpty, docker, ipaddress, jsonschema, requests2
, six, texttable, websocket_client, cached-property
, enum34, functools32
}:
buildPythonApplication rec {
  version = "1.10.0";
  name = "docker-compose-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/docker-compose/${name}.tar.gz";
    sha256 = "023y2yhkvglaq07d78i89g2p8h040d71il8nfbyg2f9fkffigx9z";
  };

  # lots of networking and other fails
  doCheck = false;
  buildInputs = [ mock pytest nose ];
  propagatedBuildInputs = [
    pyyaml backports_ssl_match_hostname colorama dockerpty docker
    ipaddress jsonschema requests2 six texttable websocket_client
    docopt cached-property
  ] ++
    stdenv.lib.optional (pythonOlder "3.4") enum34 ++
    stdenv.lib.optional (pythonOlder "3.2") functools32;

  patchPhase = ''
    # Remove upper bound on requires, see also
    # https://github.com/docker/compose/issues/4431
    sed -i "s/, < .*',$/',/" setup.py
  '';

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions/
    cp contrib/completion/bash/docker-compose $out/share/bash-completion/completions/docker-compose
  '';

  meta = with stdenv.lib; {
    homepage = "https://docs.docker.com/compose/";
    description = "Multi-container orchestration for Docker";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      jgeerds
    ];
  };
}
