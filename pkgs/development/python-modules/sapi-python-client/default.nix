{ lib, git, setuptools, setuptools-scm, fetchFromGitHub, requests, boto3, buildPythonPackage, responses }:

buildPythonPackage rec {
    pname = "sapi-python-client";
    version = "0.4.1";

    src = fetchFromGitHub {
        owner = "keboola";
        repo = pname;
        rev  = version;
        sha256 = "189dzj06vzp7366h2qsfvbjmw9qgl7jbp8syhynn9yvrjqp4k8h3";
    };

    postPatch = ''
        sed -i 's|use_scm_version=True|version="${version}"|' setup.py
    '';

    doCheck = false; # requires API token and an active keboola bucket

    nativeBuildInputs = [ git setuptools-scm ];

    propagatedBuildInputs = [ setuptools requests boto3 responses ];

    meta = with lib; {
        description = "Keboola Connection Storage API client";
        homepage = "https://github.com/keboola/sapi-python-client";
        maintainers = with maintainers; [ mrmebelman ];
        license = licenses.mit;
    };
}
