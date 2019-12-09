{ stdenv, git, setuptools, setuptools_scm, fetchgit, requests, boto3, buildPythonPackage, responses }: 

buildPythonPackage rec { 
    pname = "sapi-python-client"; 
    version = "0.1.3"; 

    src = fetchgit { 
        url = "https://github.com/keboola/sapi-python-client.git"; 
        sha256 = "1zfxz9066ddpdmyxrwvns2v8kjn5dyyqgbiaai05k4ksrrf3zv22"; 
        rev = "0.1.3"; 
    }; 

    doCheck = false; # requires API token and an active keboola bucket

    nativeBuildInputs = [ git ]; 

    propagatedBuildInputs = [ setuptools setuptools_scm ]; 

    buildInputs = [ requests boto3 responses ];

    meta = with stdenv.lib; { 
        description = "Keboola Connection Storage API client"; 
        homepage = "https://github.com/keboola/sapi-python-client"; 
        maintainers = with maintainers; [ mrmebelman ];
        license = licenses.mit; 
    }; 
}

