{ stdenv, git, setuptools, setuptools_scm, fetchFromGitHub, requests, boto3, buildPythonPackage, responses }: 

buildPythonPackage rec { 
    pname = "sapi-python-client"; 
    version = "0.1.3"; 

    src = fetchFromGitHub {
        owner = "keboola";
        repo = pname;
        rev  = version;
        sha256 = "1xja4v5d30hy26lfys21vcz1lcs88v8mvjxwl2dc3wxx2pzdvcf6";
    };

    postPatch = ''
        sed -i 's|use_scm_version=True|version="${version}"|' setup.py
    '';

    doCheck = false; # requires API token and an active keboola bucket

    nativeBuildInputs = [ git setuptools_scm ]; 

    propagatedBuildInputs = [ setuptools requests boto3 responses ]; 

    meta = with stdenv.lib; { 
        description = "Keboola Connection Storage API client"; 
        homepage = "https://github.com/keboola/sapi-python-client"; 
        maintainers = with maintainers; [ mrmebelman ];
        license = licenses.mit; 
    }; 
}

