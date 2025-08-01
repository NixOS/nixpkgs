{
  lib,
  boto3,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildMypyBoto3Package =
    serviceName: version: hash:
    buildPythonPackage {
      pname = "mypy-boto3-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        pname = "mypy_boto3_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [ boto3 ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [ "mypy_boto3_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for boto3 ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [
          fab
          mbalatsko
        ];
      };
    };
in
rec {
  mypy-boto3-accessanalyzer =
    buildMypyBoto3Package "accessanalyzer" "1.40.0"
      "sha256-hY5aShO9E5zMwPSUUucjgG2Bod0lAm51BZyLP/1JLgY=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.40.0"
      "sha256-isNBcceGQXkVPZQ9XNVGt9eCHxUidaHVJbuPmSjYOcc=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.40.0"
      "sha256-E2wUtUSMX4Lyj+HioQD6km3sGGETjgzujJbEewOHc5M=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.40.0"
      "sha256-QuPE++0Y/KxuL8yNLyUGXWExZ4UqTnXhoi/RGavS4AE=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.40.0"
      "sha256-JM/pV41mxJqdIYWzaHdAO1DtXjvQD1pzG2nU10+2IUs=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.40.0"
      "sha256-B9APRl3tgbLaWHsXOdcaYDvkpEdQRO5P1PIbQecR7lo=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.40.0"
      "sha256-1aP+5IiJI1YepuiymxtltPbNNdSNKw1dHUn11eZEEAQ=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.40.0"
      "sha256-wBdq3kI0El1XZRuGMG2lN0Zjc1GIBOItMBvctF/10Wg=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.40.0"
      "sha256-mfMTQ3XSVHDjTjQEY/EL1xq4t0KRaPwG2Nu0Pwsbk3o=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.40.0"
      "sha256-wt5RDgTkJZv+GZURGu98gGJRvM0a63JTePQ9aDrwLaE=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.40.0"
      "sha256-gfnF5uJodhhdWWdmTcD3N4GEwUZh/LsOZ9C99MPCHWQ=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.40.0"
      "sha256-n0P3k9Bs7ckTEim/cHXLQzt5qsjxzq59TYlOair61mU=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.40.0"
      "sha256-/6S/GdXeAYY9wdapWjcrCyaDmeijp6kSy63m0ITW3fs=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.40.0"
      "sha256-NtPZSYolKwbty/QgQHi5XeuBE6uDMM+hf3RRw+S9UtE=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.40.0"
      "sha256-w2NPLBdMrpFTuryOJtezSYU81kG4ZL2nIcRB0c5oL7M=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.40.0"
      "sha256-7su8sPB0QUQi+5ZQd701JYNVqpoIww3q0N4puBcszT4=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.40.0"
      "sha256-XMvGnZjdb8sQ8QES1CkZD7VkditEdudUGPVaYwF25Fk=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.40.0"
      "sha256-s1uRD7w/mw6T41zkD8PZA8+gLlcn8mWS2WGeWxk/FRc=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.40.0"
      "sha256-K5trJxvuYiP9hHB2Nz1uxKXzXrMJVwIqhU6DMVxide4=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.40.0"
      "sha256-ZMDdjJse4uyAnWIy/cwQQuAemTrUBdm8PYQp0LTuHgE=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.40.0"
      "sha256-xrpy1Eq+Kleg0oYEQY/UDXvUUdZp9B6rz4OrXo/A9bA=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.40.0"
      "sha256-TuIQx9qeu+JL1+Y3Gp83J4am1IYua7Ps40mqN8YLln8=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.40.0"
      "sha256-NgOa+Na/gU7IrtEJ8bVMJaSCNgTnGreX2TsjsAlIN+Y=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.40.0"
      "sha256-c8dkKeytZ3/lr1gWswCtcFGsHnv7F+7TOeNMNnocJhE=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.40.0"
      "sha256-2oQp9Va82Feyyf7ZEz7wv+y4mOK3TpZ586qvzCZwK/E=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.40.0"
      "sha256-ZA24MbNdmMcTygsXnfPg//NYdCh3THEs30DqP8f660A=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.40.0"
      "sha256-tBk+8scAVeO8YMNDWWW4uQK8V+X9YLUP80vm3euq3gs=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.40.0"
      "sha256-YEMDbEZoS9BxDqB+ae30NSPlQkX6gt+V6+LZjAvanKI=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.40.0"
      "sha256-q7HoaGzpwKAPik9I6e9+esVbwH2zRrIhzPQoIW4juPA=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.40.0"
      "sha256-7FIXPtt4FMjxXbHtiO4qbS4wUfi10rmVODshIORlfhs=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.40.0"
      "sha256-ntn7rj4xPShaKcOsswMdQrWmprnOcH1QyquancPI0zA=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.40.0"
      "sha256-XyGkubFi/5yoLG/5CGRNjtB7tKhOqP6PuTvhTsn3pQM=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.40.0"
      "sha256-YZKJblhTzoW0I/ozKw+RzELF9nJ0+3Z/zjZhb/lEd80=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.40.0"
      "sha256-nY9RvXgjyeNsiuVtM+2pWsc0kGuAggZNpkF7SXkHVwk=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.40.0"
      "sha256-O42YFgtlQoivQquLiQqHoHiT5NtQH8I4z6H+A41rrSE=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.40.0"
      "sha256-g4dwXPkMmQxjaSZt1RvRvVxRXWyeFosmwMaiCOtvuqY=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.40.0"
      "sha256-oPAwpEyXLywiumiOZ5b6YzplIHa10a4b5zMyb0M2IAU=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.40.0"
      "sha256-P+I+mG7Bhf83/Mdt3HG5y/nWiKTEjIjTebcBfZ789sY=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.40.0"
      "sha256-8BL5bNgUJegDMQnyGnLjSxzaPATF80av0lk+D+bEqgI=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.40.0"
      "sha256-Vtf4PVkKxCIYSyvOXMMo1r7ZskDVA0zw9Ql0elCsw28=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.40.0"
      "sha256-4gZRcx2z2PJcm/q1X7Ufe8RAAyHNhPEawRiLBWeWC+A=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.40.0"
      "sha256-pb1knX+zPd5xbTx8ilHmnD3WZUOzmBbiIzvORb3P6XQ=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.40.0"
      "sha256-zs2trO/LmdKEyP+xhjHZCnWrI5loGEc7AiSQ7Hpq0rg=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.40.0"
      "sha256-38IFJI1enFd6XnWe81zuf80N23Orfl1CUCRt57g0zEE=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.40.0"
      "sha256-kMDdPCPFcwKQR5/MAlbyvGY4o7PHwQzQVGkzWLRg7Sk=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.40.0"
      "sha256-oL6q5WNV+z5etEOdZakZqeYfbqL2n/vwoD/WtFrYlfA=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.40.0"
      "sha256-RLASB36ERKJztiCVAlVWIStWmsg6638oX4WSGnNR6e4=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.40.0"
      "sha256-GqcCTcfrPGdt1F2e2kFBZVJuK30sFiP+JSXYXV/sH7g=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.40.0"
      "sha256-h/dMWTcSGu7IuI2G2G+gt3EbWV1SA4JpOcYiMtlGUxs=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.40.0"
      "sha256-sWGWNB+dBURSQhopDDm5rXsvolhDVi8oRshfG57vbw0=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.40.0"
      "sha256-pxLDikSrl8gZsvYbpmafQt4EG72lsrv4VESXTCuVQzc=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.40.0"
      "sha256-aV+fpcURVMZv7jOsZ/LF6edo4doNZPtCwdG4YEGKMYc=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.40.0"
      "sha256-1UfkYWjdEHdYQff3xCTH3jQapWyzc/L9pznEc/o5Stg=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.40.0"
      "sha256-SbEKbGXjkvk+jIXQHToTj+yzhUX1ob8VzT4awbWUAWs=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.40.0"
      "sha256-FyjlcLmx8cmYlTlzxI8AupyGJXwIWEh7OOtKeUA6vPk=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.40.0"
      "sha256-FFbyglD7Cuwp20RutRBXu7X097WK+gLfbzhWE7CrPyI=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.40.0"
      "sha256-cPLylCvda6iHWRcPMVaL/qEkeg7EzBs38G2mX1eP0ZI=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.40.0"
      "sha256-buG7f7h5ciaoS7Pq/8u8PsvAmqaJqYr4+rIiXxUVqaI=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.40.0"
      "sha256-jCHj0zHPXgQ303eM9naE4hr+6GP8OhjR8UeX6OeTEIU=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.40.0"
      "sha256-DGppntoDyUYwAo1XkJG7OQTK/E0B4F9y2qjnIQaRT7I=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.40.0"
      "sha256-T++PZg1Q9GQpdpMrkOXpMaW3NZe9bKgJAmqLflvJXgc=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.40.0"
      "sha256-C9gZsTj4dK7evyAo8v1DbSo4vIm+HIzth+m/F0OPigk=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.40.0"
      "sha256-wWJVXhlaRSBmDs0rA+Uqa36yBShPzUqFYB7qkkTCteg=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.40.0"
      "sha256-MJfhLtZ7XJxOvfnYruvPGr6yl7Dg71iKC65b57s3YUw=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.40.0"
      "sha256-AsC0tMY0LbaFxJgLK3QLDrXNOjLkZkvp60AwyQEkeRw=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.40.0"
      "sha256-uEEXHsqyaLnPGXs0wVrx+cjUkm8IykxTnWeBOBXb3DU=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.40.0"
      "sha256-IuXn0o68VmKHRc4Njoo/0XKvxPKPxMsI17letOqO4Do=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.40.0"
      "sha256-3BylDhj1qWTDr/xeUxdnrKNXbXisMgXL0OoThhdoSZg=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.40.0"
      "sha256-KVfYSlwqY7/ufb+DEChO5Df3bfX0nw2W60YZW7UXSgk=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.40.0"
      "sha256-oJFrBdUov2dpl4XWV3HGHigKTvLAUtD2x1gzxzeK5oA=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.40.0"
      "sha256-CSfC9Kg73LydRU5aH4kqdc0pJWqEf98ebu6FOBE7oVU=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.40.0"
      "sha256-eukD7L3JzqvzK5mW9ESu9L62id1EHGhYdy+afYowtAc=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.40.0"
      "sha256-RhIoRVpH8EaPKuhcui+1HwOER+CPqLJuKQ3qs3kUsEo=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.40.0"
      "sha256-sRuNGX0Xy9sQmHpWZtjbMYTSFgAzTAuNke4uHINz9q8=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.40.0"
      "sha256-nAOKVy+aH2gw8NZ8cNSYqQ0kFWV4Gb4oU6y1vHz3fpI=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.40.0"
      "sha256-dDHPNM+HVEIBXu9GFRtnnY+j5J31Z0gNfv/cd91QX4I=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.40.0"
      "sha256-+dXdtfYLf5LclRoNazidUwu9uClEFXi286bGgAVbWYU=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.40.0"
      "sha256-boRrDWiYtyKWUimJ7yb3uYPGSB/tmI2sEXNFacAPDic=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.40.0"
      "sha256-swFOOGB/iVP98EUOfTohHCxzrLNf1bnX/cbQWC83PVw=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.40.0"
      "sha256-fMWdXDlTjSkf5R5U+cd85E5qEEHAyl4Mc0v1W2rW4WA=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.40.0"
      "sha256-pw+1wvGLr4uYdUuAnDwSQeJ0KLe9JNzfRYnZJTTNrIU=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.40.0"
      "sha256-VVmG1myGH8FJpqQ63GDMYH5KVAPsv+Pmnc/WxHpTcHs=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.40.0"
      "sha256-QhTjQ1ZZX8zQzna2rUu2zF5jd51E4mJ/+v45sd9p3lA=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.40.0"
      "sha256-I5xvx5UCp1h2H1c2xI6mSI4ZaXsONs/09/BJfRXCr3A=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.40.0"
      "sha256-8WIQT3ZFLScp4zge1Cu5OkxeXS9GCCPdYlwJPwwz1GU=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.40.0"
      "sha256-npKb6WwOkXnxh5YYQ4spoS17J5oyzI4u1hw/2+d7dH0=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.40.0"
      "sha256-6v65flOExW7V8UfoyPaBcUQDYjhJ2jyuQpXMZW+ajCI=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.40.0"
      "sha256-aQR1CrCbisf0vApIjFXa5/oKC4Q1eT0AsLTg0EBojAs=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.40.0"
      "sha256-UmrcCxy3zK/cEkM/KCGnr4JEMOOjhNwBNRC6IiMm+NM=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.40.0"
      "sha256-7B/r3hmwde2URQF3ztv3Ruva+0IPq2uNAoY4lAHga80=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.40.0"
      "sha256-t+aKxZaK2Zx6QQ2AmlCUpjXhFtcma+nOKMXF1bkRfBY=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.40.0"
      "sha256-JT+/tWyrcEXCiPhfcJQYXsPAwKCKLPu+c3A+r4iJIVg=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.40.0"
      "sha256-GH91jmgaNkchW2fK8winBTP4IWUftwqFCqfJPqkDj9o=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.40.0"
      "sha256-TKVaVd92g+2bV5NNRnLuVZQw0lZycTyeyjB6UgV+iHc=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.40.0"
      "sha256-dtw54zAzP4HddWx0kZr7SzxmWiKCiiP6g4+aDRRid2k=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.40.0"
      "sha256-MjtEiMiKguv1RAeY4Cjk/apJlgi5jH/6avgMtdcp+2Q=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.40.0"
      "sha256-l/ZQBqFwb3y99TrRw6mRThC1N1QZTbStEgBOynw3a04=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.40.0"
      "sha256-x/0Scc259VN45rx94YT48Q3NS7nnd2oNRgxQAmy3nSQ=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.40.0"
      "sha256-p+NFAi4x4J6S4v0f2u0awDG+lb2V7r3XwgYwl5CvhHo=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.40.0"
      "sha256-iyPAkVpfnqz2RX12klUOTH2NaFO/tAfiWFXLF+FHGe0=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.40.0"
      "sha256-YmD2QCD6oc8HB3yNpj/ucXrbF3KVuVNiW8rK4UzPxGw=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.40.0"
      "sha256-dzPkK8ipL/2Tvr8DQ68TP9UmmP/r0yPYL/3nVc4oaH8=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.40.0"
      "sha256-/BYvjLnsA+u/7Jy54ApT9Ss5acGB6FFBzrWhby8ctxA=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.40.0"
      "sha256-f6FsEABh57bwQ+ffj4b0qds+7X5JGKyDRfuVR2W4J4A=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.40.0"
      "sha256-DQZUI72cnRt4YwHMQivMdL4y9B9EN2H7dIMmybcX/Uk=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.40.0"
      "sha256-bfQxrWlOJQJVJ/pSyzdkaj5vN3tE8PbH2ioeJmEetpc=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.40.0"
      "sha256-wOxSRFLJHcO1Vc26rFKaxe49l5/PKAxDBycvV0ER1Co=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.40.0"
      "sha256-uMYIfSNSkNPJnpRgCeM+HVccKZbxyrSXgkfvq+WyoAk=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.40.0"
      "sha256-4xpjAgNDfYP3Z8uPxINsLOQ1vvanXW1/QDbUcZ57e0Y=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.40.0"
      "sha256-/VNUPoXCvu+XIbq81YPL7wN1aCnec5K4Vv3ysVr2+eI=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.40.0"
      "sha256-zxpAc7Z4Vm6Bzdq7bhdekg6HAUKe/3PXRviQ0f8p7NE=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.40.0"
      "sha256-crNaa6bqSP7fCsFV5CnAHazDpXrFkkb46ria2LWTDvY=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.40.0"
      "sha256-69FemTAsiAMYEcITc+5xrg+swrxgILdj3CwmgIIMi0c=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.40.0"
      "sha256-9Iz9FapUQCWa9bjmH0Ar9O1mtTv+ovWlxikddb5+Wlc=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.40.0"
      "sha256-/Xzo0KU2N14S39gkb1MnJV27anIN92ANcCbKl1b9YVw=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.40.0"
      "sha256-0lQVhW0/lc/xsR7QN66dMmT5ApN+SxYDZk78liqtqi4=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.40.0"
      "sha256-NifbOgZ8Q0oUnKchIt04RgMMDBXMiwJJCKDmax3j4Es=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.40.0"
      "sha256-pqXtqKztmI4gOfyvwgjNg0MShL/RPwVQhdcHHGlw7Qk=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.40.0"
      "sha256-rIdTU3A6jN0cpn6kQE0nPSqjYPqXUF2yyjMuvpnejpE=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.40.0"
      "sha256-jX1fYURsKptrn7rtyoekqvS81P42GiW5J7kS9aKw1c0=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.40.0"
      "sha256-Zzp7VoPaVIHX3KccxlFILesGNJP7f1p63uXLwN3rLcs=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.40.0"
      "sha256-0mNCSnKz/OTCM4vSwdSxkMVPEhsiYUOY+b+6wL/sIyM=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.40.0"
      "sha256-sTuTQ3ADgiApY0davzOBHz+jz21tp2C4L7Kq6j8dUvY=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.40.0"
      "sha256-mo2xp2XnApilK6zB+KZLt/KcJ6mTPskjidfZ0ju6Xss=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.40.0"
      "sha256-J/cpFdOZUL5B1LxtIBOnE++TdSA1sbqA7ckJ+Ag1Os0=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.40.0"
      "sha256-i76hozLLcN4Y5Jpg/92+6FSgStpw2SfF0HeRhQiRPqE=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.40.0"
      "sha256-ryCVtTJSbtLmStHUhZrNkUBm79mjZo4NZtf5QHONWLY=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.40.0"
      "sha256-KgMMWys21dHhDP9kQjxPeQtJBWfiOeSCtwuE9FIAzk8=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.40.0"
      "sha256-NBSrlhycsJqCgbiitfNmSAGcTPgZfkfx5DGm8ZhrRyc=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.40.0"
      "sha256-So/NDL0KF5iypLYitnJ/38C5RovqBGXcUhHtlEMnjMM=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.40.0"
      "sha256-mrP7ztL3Pl4/pJlAtn+eq2TEFX9kWRBT7GsK0oJKDuk=";

  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.40.0"
      "sha256-KQqyk9PFUttzDrZW7viev8xbumdud05EBdNoxz//hEY=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.40.0"
      "sha256-LjQRVGdaDoTkLT+FRRt5adFZhzrjV+q2s9HyBrR0pdQ=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.40.0"
      "sha256-FMt0y3H1PQ8I7VdZvh/spGzluAmfPFEXypcR8zsebdM=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.40.0"
      "sha256-/LlMFYC7cJWb9C5JIt0dTEPtl2sPsalSq7mYaFSf3c4=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.40.0"
      "sha256-tKp7/s70JDEPxMzSQ1Vr1Cd126VrmumKGtRLBG2Kp9Q=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.40.0"
      "sha256-c/QCgM8mWIAe76C7e3+g9z3i/ukvOz9QGungofo2hY8=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.40.0"
      "sha256-zsVA9tf4try58FeHrxsVdXxdN9d1UpLiebb6tViGZ3k=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.40.0"
      "sha256-uQCsVXN1Qo8LvDeqJP3SkB4ttwGK5E4Kr5nsD4SijUQ=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.40.0"
      "sha256-RLcGOVDiwryD6xf9E6lWSdAAIKCP4hNaBQknjbwPAuQ=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.40.0"
      "sha256-Mcp5NCJal9YyJ9bQN9q/M0E/pXvXiDlLGvAqpCo2xLs=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.40.0"
      "sha256-ba01dCNMlcTw/+WrulQkCtDagcPO7FF94cgkY14Pgsg=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.40.0"
      "sha256-qreFTjlz+Mcr3dcgHGMjfV0GPF2SfE/zV+FN26JHa0A=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.40.0"
      "sha256-JW7UUuvWlc2YHmK/BeSxI22xQA5NZuq1kHvWWVdkG30=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.40.0"
      "sha256-mZfvKN+x91U1yjBwo4pKZN6jCnUMbl8SnwWF3IMx+ko=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.40.0"
      "sha256-0AUK0HaqmoLVbbLDcsagUZX7KkFF9zU7obO0BmcK8+s=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.40.0"
      "sha256-NkJju++RcjTAI2kEwcTuknZGKNkg/eM+MJcgV5dsuPI=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.40.0"
      "sha256-NH8dQFWdA5jiZnCFGcfDV1RI/fULth9kI1kNlmV2z8Y=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.40.0"
      "sha256-llbeFHGDeVXv++P6wtIh+lwMbVlNPIpDim7s5Ux4MV8=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.40.0"
      "sha256-mo2XR9wv93818e+usfVTp3m/NbZndY8bSbiTZa+TrSI=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.40.0"
      "sha256-3PlH9KqX9zXYayYoseqio20l34nt34YYrp8Zmu/9yIs=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.40.0"
      "sha256-sIOK6xeN9S4rW+SIdhdHuHEeu4Z1t9xiBQfgspSJYSc=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.40.0"
      "sha256-U2nCifkYupb+DcMn8JjPUM+dCROsyyZGukChsaDNROE=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.40.0"
      "sha256-PER1D68w6wBvHUH5CGEn4H1zku92vhcwWDFRpoXZlmg=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.40.0"
      "sha256-E1l57KrYP3ggjLVj94kzBB85CFF7HtldUMHGZP7aUEo=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.39.15"
      "sha256-qtp/WNjBgnFOjBD1hJGssRETgb0fZsYK6ts+7KjIx/E=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.39.0"
      "sha256-lYi3aVAn8lAxuhhOiLhrWehLwVyEshErW9ccrD+Rsq4=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.39.0"
      "sha256-uuYtLyzgiNttKZ8tpH8gRidBqRSvOJmIv/PgbaDGjCQ=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.39.17"
      "sha256-C/BE7hpb30LKAJQwNJuBIA6dtKs92MrdwfAiubvkJlY=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.39.0"
      "sha256-oydIwNjQkQOGYBhPWO9Of2esL7UYQaZ+p+dp6DkZkIk=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.39.0"
      "sha256-bjw15elzFebQdag2wFKV3b+a7jiejTx9F7K6M0nGx80=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.39.0"
      "sha256-8nkdI9zPCJ8hB/9/AyuVTWsNv7VONLlIFnUKf8yZs5g=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.39.0"
      "sha256-R7u4skvPRHs1DHm/Rnn98DOxJCIL5iu8uhGpGol6hoY=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.39.0"
      "sha256-5lpvww4JaOsVgO96KrBIM54l1+6lJT9pvS2ZpYFkros=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.39.0"
      "sha256-V5cRYr/2YzcwG4QWtwzdcu/xDZ+GfPrO0D2efjWaraE=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.39.0"
      "sha256-yvd58t0IO8dJehf+WRyQtvKKiN8YygP2+akUAkb6b94=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.39.0"
      "sha256-WwDwy8l+2i+FSPx1+rfGh4BVYuvuH0/vhqB9kaQ0Yyg=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.39.0"
      "sha256-z5sB2KGUQpn+plvnTXKzKxpSEPqWgThxhK8uLC9M6gQ=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.39.0"
      "sha256-6MivZehh2aj1Ff45b/qodNqEpP/N2oSnnpWRmJcUbYc=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.39.0"
      "sha256-b8ye28vqiEoWH2DWrahq1//E5iNPhFeb+ginLrWI2Vc=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.39.0"
      "sha256-gUL21wiArXb6na/Zz1SttEMzyB0Ttwl8yjVpr8gzyeg=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.39.0"
      "sha256-GkDIK9Anw9KMlkzn9rbXxdVozBzT04mKwKb1iZI0jMk=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.39.0"
      "sha256-47T+iYAsNNxptVTVPK35YwDtY2MYMa6/WIhkxJnOeQA=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.39.0"
      "sha256-AFSYgr0+FiPW6bnIIW2PdeGgOAwP7uz8kGVHx3s69KM=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.39.0"
      "sha256-4O3YwpoJd0hMIvNLIoH6pQfHAB+SXxGvuJ/ZBAXIizI=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.39.14"
      "sha256-HKOO9AXAt3ZIj1dgftxszcfkJjGtrSPcZKufye/HKrQ=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.39.0"
      "sha256-UMrR80IPpkYrz4iBsArrjWbt+n58KmNOIFUUlp05eNk=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.39.11"
      "sha256-qYZ7pUztjP0el3r67gU9EmTI1k7yFf6NEyuaOkc2/gc=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.39.0"
      "sha256-lhlDLL9ZRBhqPIBcawwdmymASqToRvafMNWs0UR0I5I=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.39.0"
      "sha256-8Aa/Ee66Cc827RREJixa0EEBzRg2B5RdrEJEq9KAnlI=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.39.0"
      "sha256-sgF1dqAX2KxU7wA1g+Q71AJx5iaufYufvroYMOqYNjw=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.39.0"
      "sha256-hT6+b8/ZM8es6HyqsNvSX/RPe4nlI5Lla6hjm4xxLWw=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.39.0"
      "sha256-stGg1Ck1PRJ4IU/ToEVYpzUvB7kbeHQKDN00FcOz7sk=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.39.0"
      "sha256-4zwMgvDJLqq6dtXaA4+B36kX0zZtAvdubexZ5ZFqmkY=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.39.0"
      "sha256-XhIKtiCrvP9K9+ud4FkhgUYNtvQaQ6I05mMUQhwuUhs=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.39.0"
      "sha256-nKniYx8pYpGOA4Zz560MDdcLWkV2lULW99ur+gSg0YY=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.39.16"
      "sha256-NVIOUNvDYSsksS2QyRwjxKGvupbju4G4ArqGaZOfPEQ=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.39.9"
      "sha256-MWIOrYbIA3PG6ComGabQs7SkV9CwdqE/gUQ+pjm7+h4=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.39.0"
      "sha256-YfvZuDet0Se8VHWiHQYkiQIDuCOyntRYkQ/lK80xl/Q=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.39.0"
      "sha256-vcbKaQoyk/Z6RdmPrfNggyw9Y5fRcrjdBLWNwzPsZkY=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.39.0"
      "sha256-pDw22yb/QACFekLOTYBiqaL6Jl7L1kPetKXt9l4qaWg=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.39.0"
      "sha256-VdNJBkkm9VSM4+J+Okw+Lw2PzouIaY10k5SBc7O/oqA=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.39.0"
      "sha256-+mzbNEWaxzZ8ApJLdKrCtDzHs5bnSq32JAVXyrXj2O4=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.39.0"
      "sha256-fqfRqbyQHzv/el8Ok2Pl5oCIOC7YbMXf1cUHQ0+L7zs=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.39.0"
      "sha256-1uuiKfr1Yo+N4HkCEm9BLA4+ceVcFUtSDJ2IWuJiavI=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.39.0"
      "sha256-n0cdz1JNJotqCormhIBbKDWlSDtKE3Xbrf6+Qp9UByc=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.39.0"
      "sha256-DLyeKTOL6i99c4FkwZ25wG0T36bjI33gFpciKJ7kgFA=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.39.0"
      "sha256-T08rscbFIMq3HVwcoyI19qwLzRyGmbOmPNWeNlqN3C4=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.39.0"
      "sha256-ol0uDVgU4zwjy6H1u5B+t/wg9bxptXvg9GuRW/JcTV8=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.39.0"
      "sha256-lV6OYMq38rygAB43zS+JqEmB9Jf1im/kBGTC01NquT0=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.39.9"
      "sha256-Lfr3j+tyf5BNz8MSc10Jtv5EeIdjVPep/GbWdqapMyw=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.39.0"
      "sha256-5J3pjXFJH6oED2Sf77mJF6GbnIKo7dRlaUqu0Hz8+P0=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.39.0"
      "sha256-bBAUIrwY0dxGeaYDGIhFvsjeAM92qa5duiH1Jj5nhrc=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.39.0"
      "sha256-m2GQMKzrBEiKkk8gBhRvETEe4SplH5l/GYpc86wwBG0=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.39.14"
      "sha256-X5RvEr/I1Yj0IeCUGtNA92FzmqZY/grri8pgs0NVtqg=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.39.0"
      "sha256-yKAYER5kU5GxbLZTWBDI7ztscyG8KZ4T+d8+fr6GCnY=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.39.0"
      "sha256-JrfzF5valQYWc598YkOByq3EQupgtrAEg2V5kqdMQP0=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.39.0"
      "sha256-+HRH0bbDiM5v8sdoumUcSBFswTTtpseblE6bHKcttoA=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.39.0"
      "sha256-mpb71EvyDhu7kua6jCo/GWtVF/Gt+21NFamSBwv1buM=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.39.0"
      "sha256-HEs9foDI/P8gSMxYRX6PqMLNVLgoZ0KTeTfMVgzBPEM=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.39.0"
      "sha256-vgQbE3GPYOg+RGdqDyjAcWDzntFvpnvxh5X0DM6U20k=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.39.0"
      "sha256-iAaydi0o4OxHNdIIogr44sC8sIE3U4+MYlh2erN/cFU=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.39.0"
      "sha256-22Uh8OcSaeDn37jV6VtSg27yZQ/CUeWjEmueYs4rYYw=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.39.0"
      "sha256-1yVAexi7t34bo9YyWsGJMkA2387GhtH6DaU3hYB2l7A=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.39.0"
      "sha256-DhCYpX0vokfQHMn/gGMzCiZSi2sEu8RILd4mOb6B0Co=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.39.0"
      "sha256-0yM/LqZBjxcG5v1cYPHX1v7ccF80Mrcn+oe45WmSbhw=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.39.0"
      "sha256-/Rs4JJHhrtiEC5WyjF3vhIMwsbxQ14dKz64RunyQtpc=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.39.0"
      "sha256-ko+vErrLlQ1Bpp+Jb7VVuQ2BgxCxeICEvf46MLuoWWE=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.39.0"
      "sha256-rLywlCoxVge71jHv9x+hjRnSQnwy9SamLCrPp2b8cRY=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.39.0"
      "sha256-/mWDcx3kmgq10rP25M9Jb3jK7wM5qlqoyliwQyrm8oE=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.39.0"
      "sha256-q8NsWE/syMihH6TE1b1nBFgHhNavOBaFdwgQnDQXrXs=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.39.11"
      "sha256-KdPpWb+esR94Abnfs1K09qf2MWfTkj28yLRSg/1QCFI=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.39.0"
      "sha256-qTznhEBvkUuAJPPR7WBAc/3O2s6hl/FKYi/FEp5w45k=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.39.0"
      "sha256-PzQpv8ULGeOuQlnmoDrngPSVzjU9ZqFQVtxPMHrAveU=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.39.0"
      "sha256-FvlItvDTdy6snW2oENJGKnGQi/6FGytV+PVaJNXH7Nk=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.39.13"
      "sha256-iPx1rzAdu0DsTJRVWdJGCgSy+dzwykIQaXwiZt/zYxg=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.39.5"
      "sha256-GVl2DEuM5xkd0Jm1zJW6tYr6990GnYjlZ5xi2roPUss=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.39.16"
      "sha256-XPh84t1HB54OjefWTz6fQ9yl66GM4qruD2jFKEAWJC4=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.39.0"
      "sha256-tDHqekgcelTHYZze0rvuHHMseiyZF7ZL9VY3LVvvA8I=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.39.4"
      "sha256-agKU7FBT2mFP4OXgOG0Io5BdOnh3IDIngs7iPU8VLLs=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.39.0"
      "sha256-Ntxi/vlYmPzqrO/Q+sTaOqGB/gnaIThrEcrdcmNawBo=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.39.15"
      "sha256-2CyrEtINnLIV9qUPrPgDwD4YDXSjlTBPQtHEMohB2Bg=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.39.9"
      "sha256-+itEE+n2N2N9BqHA7N8dWES7sJFIQRa5IqA8BEclkZI=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.39.0"
      "sha256-2JL1gN5+ZiofUpo+tu39yC41B1Xhn7vaktDVaGF5olc=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.39.0"
      "sha256-OV9iSYwKhK3swHMjEPLld/YddXvHUZ4NBdxqgX5bfSY=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.39.7"
      "sha256-X5sPv812kQ/+YkfDLBcEpTsPpmxaM0pTpd+ssbKzXB8=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.39.0"
      "sha256-Chwpz+gUvf5KBJDH9Gh3E8cQcgc27fHgYUdoUztijTc=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.39.0"
      "sha256-dybCgTPmJLuGI3SfIB4fHDxs0vcJ2QG6K6j1Mj2Y24o=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.39.0"
      "sha256-iYQ17ZFu5hGkVoyYXcRN3/uHUvXlzxuRdyxwRzkbybU=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.39.0"
      "sha256-5In5YQlxlikaJbAmck01uwMVjsvs0npFtPnspQNc5yY=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.39.0"
      "sha256-QTJka8H0wXoxlXWLic7k/npSuVtgEfyvUSUOfbpJZls=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.39.0"
      "sha256-/5X1IDvRJSEzDe53Rr1RgAiDPqGTbF4zNFXR7wtV/8o=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.39.0"
      "sha256-EqQ2bNrwGVOTz2bUfFqIYlKCijT60Wuqj07hzCaVLQI=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.39.0"
      "sha256-maRyGKDrOUxw0sNW0VmKtjJDDETLeHA6to7c8s/LAvs=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.39.0"
      "sha256-W6wdFMDopYaVtsYPRFt0C2XVLKuoZp75C2ndGEQpjkM=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.39.0"
      "sha256-sqQ5B5mPP46aH7Taounz9P4mmAB+OM9ZfJQgTeRbhGc=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.39.0"
      "sha256-3MoTYkhWWNDVMHsQvfFNPv2Gax6MGfDirAJMjJEukCY=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.39.5"
      "sha256-KVd2ZoJF4byRAfogtMw7w9hoTK1eaCKYrwJc99+4FK8=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.39.0"
      "sha256-Q3Ze5ckvB6gtFpLT6jZ555GYcCNVT/jyWR43wvDkyhs=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.39.0"
      "sha256-btHNiBbN6LozZFweRPcGcoA+lvtEKceiYBnVvl4hoIU=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.39.0"
      "sha256-FP0MEiK2+lkRtRxNBWgIGYottfyVH/L1AjG+8j1BWI8=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.39.5"
      "sha256-tMTUaV1y3CrDqBVPgxdgboXRjbEXUZaOexfNHNfMuVM=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.39.0"
      "sha256-VS6ico3IN5+uAzOZ5NkmZtPIMgV8Vf2eIUWYnhSKlv0=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.39.0"
      "sha256-4BGjmT0w3PbYn2Sh7tup1e97NgQa+3Mm8ckgcKZFUs4=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.39.1"
      "sha256-a5W7NPPxPlxOkClHCCikcGhFMENw33cyIWIu6dXQADM=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.39.0"
      "sha256-uLbSzMm+q5JgY1eNYB9wu22ahSeKcf2evjyAypuHv+o=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.39.0"
      "sha256-vnGlWu8OCUPE6iJmpg4tm3XXWUdCaw0LF/H2AgPi1e0=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.39.0"
      "sha256-l/+S4YpkykWj1B2nv7hhn567ignC3aciCOUEca8l3Rc=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.39.0"
      "sha256-72LJFKWU9oioDuK1XKbeYAOZYth5zBEezMfKnh4zjh4=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.39.0"
      "sha256-tZjhb1MZ90mMARS/aE3QYDJYvDc8QaI5lN66WjHK9yM=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.39.0"
      "sha256-lwaekfAb40vMpGtEJo9piWKmvxIjG9rfnPV5edQ/+Rc=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.39.0"
      "sha256-7rwIzQpArL3GsNYGrEWqg+C2WEwHAVNknMJLniMMz8A=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.39.0"
      "sha256-Wu/MojGMHwkEk1WpeMZpJj6k7IBOV6oLfjPDSGSuHys=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.39.0"
      "sha256-1GiS6t1o2p/7og9B3QuYv50ERAod9wkTyRmyFuGOO0o=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.39.0"
      "sha256-VmvWQhq0ohZb/yOR0EOpxpx+Yky1/8oIl39uh5qz204=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.39.0"
      "sha256-xeHtQ7GrJz53fAK+ah15SDi6+vJXGJVjUWN6a4qyA+M=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.39.3"
      "sha256-r05/+JWzvNZHiUMNns78PPkale53vfPCIHK5kQoA2hU=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.39.0"
      "sha256-MtMms91fU7bsi4qPAJY457zIqyl7nzSn7QZ4p29bZBs=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.39.0"
      "sha256-O9486aJfTczvFtKgLLqeY9XBqu8hWWCLSWmBMXGOpJg=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.39.0"
      "sha256-UJzNS/qQhGxw3Ej06zbZLdzV6gWY7FShPO+bkZQm97M=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.39.0"
      "sha256-sXhNog52dOwqBYzbFUGiDRq7CpCeT7CHnEwi24uodyY=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.39.0"
      "sha256-UQnad31MTWWyWU9qroFhGAAcl94YOOdO2Cc4UxYX9/c=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.39.0"
      "sha256-MWw9jSrR4rJP3y+FXjt4vvckjh9lQ0IDZLA7wqA90q4=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.39.5"
      "sha256-szmpEo6W6vdPh8QO5CcR24LTGkUIW6eLJirnaDy55fA=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.39.2"
      "sha256-KIwVQgvR3sITCkqYS1zkp1QWz0qnpb7EwrvB6GHTC9c=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.39.0"
      "sha256-vW033S6oYNQN+iCLiDEGbgaNOxjDM0FK0P/SrSHEprA=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.39.10"
      "sha256-jqLHNFIZ4P03QO0NgXzU9V0RdLbR/i0er6VPk4QDbks=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.39.0"
      "sha256-rdfL40k8Gp5oRhvsOuI0AIi7GXc9ORoc7XXWv+DXN+8=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.39.0"
      "sha256-GBfxhKK14ZR0l07RRSLdmbXLkgzbfZ/8nnNhvaq5EWc=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.39.0"
      "sha256-rDc80pZ+8/rc8fyPaA2PEU5hnHvmUVeanAWaYb5ehTU=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.39.0"
      "sha256-kbn43J3H8HLSjQwON1iUf7NSTuE/VH7kiEqELS8IRTo=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.39.0"
      "sha256-R74pc2FXljPg/oQHfsE4SLM7Bb1RIED8YiBm4GNEoS8=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.39.0"
      "sha256-sX6U6gjC4AvLkeb7BnRzZRrpePUBrSwHVyDD3DKmZzY=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.39.0"
      "sha256-i0my8J02k968z5iRUF68nd+PBE+DdptcRfkoAFk9trA=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.39.0"
      "sha256-kf9OfUt1NTZCaJ05mdkKgaYLKOG1bMUuA74rzFVEy28=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.39.0"
      "sha256-qW6/zBZ6qOcQipRU9i9LwFg75vMQwot791YwKPBwojU=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.39.0"
      "sha256-Li8YWTTnz3dwKm6gYPVgOZsSD/Gj6KnUALd1EQ05aLw=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.39.0"
      "sha256-4FS9hulCzybBNZZWShVtn02sTcckefHF0fr6nPIxKQ0=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.39.0"
      "sha256-S7yyzHq81a79tFKbXM5HUWguH/fkJY+e4yd5AjlhmBY=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.39.0"
      "sha256-VfdL346SbTv9WWoOhYGb6INfT8Wgs+WqxId1nC3eYmE=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.39.0"
      "sha256-0Ak/2JAfm5mKNN3CDrYaverNgPVFo/1IXPj0bgTPXjc=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.39.0"
      "sha256-DO8738HiBClei+6YFFNQoDudW5TRp57oDahf5VRtK50=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.39.0"
      "sha256-uyLPpCRxCpFf1HrkJVEEXPoorreXG+LoYqojiVno2ns=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.39.0"
      "sha256-XusVvO3VKqiOHD8W+XPvsULsHzJW90kV8qp8eIwb5Ec=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.39.0"
      "sha256-g+Vz681TnxkhJutrBY87UFDsCVXSaa3tB59+EpsCS/Y=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.39.0"
      "sha256-imN2VXToIDkhqiU6GZempGOgWaRLxResmXnOCQfp7pk=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.39.9"
      "sha256-GI5QgUalRnZWcE++zbvHOtqHKyZJ/ZRlqsglg1gWoqE=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.39.0"
      "sha256-fFlG+baqHWYZdyw+IrnCLIaf2enoVzx6pbrxTHKEPqA=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.39.0"
      "sha256-HS8XyeXbAVl03F3y15GA676SYFNItVntEaWhO6RUxw4=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.39.0"
      "sha256-tH1fnUEgM+gUyhKeNwQSDmu1UNZGVCPWtXwoFWSVwvM=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.39.0"
      "sha256-lVgVz0/6xEOJ1UgcHtMbiQ5NLHX4Ns6gS/vtMUVLPM4=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.39.0"
      "sha256-j/noAQJqsCZ7vISTVhP8oCkUoP9Fy9x9KCvHzuC/HEA=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.39.0"
      "sha256-E6/NI8yNiImY0qF2jXRBjnNwvA5DwUua/E4caFQRzWA=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.39.0"
      "sha256-pW6TPUN9BkawWJUe7Mkv/GCvguzEb15Q+hrp22oic4E=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.39.14"
      "sha256-YFcAbN+G8sLzZ27WV0xBKZD9EqRBKzoLlVanySJJPKc=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.39.9"
      "sha256-dfLKgVVogDKIFDnmQEH9jStBqvUv2eMRvzBSS3OsM4A=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.39.0"
      "sha256-FPvrX+aqYagjpiyICVhuvDGmjlzP3xnf/zjZdfMvGTc=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.39.0"
      "sha256-t5SediKY5Gg6sQxvAEyIF4ThGdH/lcyiReQ+7XZ/t9A=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.39.0"
      "sha256-AnjvGW2jYDLaSR2GI9qTuPWbxhbrvpe5Rj6JEqZG7No=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.39.0"
      "sha256-itZYpd6jkx0bnt2NrE6KKLKJyL4zVgd9zP7Dee8SWhU=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.39.0"
      "sha256-sWOpD9d0oLodkWk4OMw61WdoL85VMehc1q6Rc+7Oo8o=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.39.0"
      "sha256-Cc3eTbro2qQ1x+r6Us0125nLZGIm28GXuvjLvx7OdVw=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.39.8"
      "sha256-6eLSFjwfUE6BFYyYJekyj5P5MbwBqIQBMRym1pA67sk=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.39.0"
      "sha256-XLb8v1eMYCDSrG8B6JUr96kUhGxL1c5kdH1jiO1Xi3I=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.39.0"
      "sha256-c4oozOAJ8VolQVaqOKyChBt3x5M/dCxJnK1IgLObYQI=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.39.0"
      "sha256-exZAQ11wtsTZsZFhYn1BzzHpC4Y+82l/8wBOtCh9I9o=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.39.0"
      "sha256-ol/7F+j73vtQYjxiZhn9rToqK+WMcS27eni2FnBw228=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.39.0"
      "sha256-bX6nxgcmAQudjbMK53TAtaJUx/GM0F4t7CXIsWaE64E=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.39.8"
      "sha256-oEWsMardjPV3ZlyStCdvZxDaKxE4ewq4MYiO6xAxuN4=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.39.0"
      "sha256-lf9f2Ax02hCkjp/+iHnYbMoGyWnAL/zn/FfSo1nSITs=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.39.0"
      "sha256-BoJXUz500qUZW4e5/kXMEg+leev4Wb3U2KlIG8sRL+8=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.39.0"
      "sha256-/22MdrrbNeSOvHoilrXnrWfX4EfElRX2rGmE+trhd4k=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.39.0"
      "sha256-BfHbf/YBfOTji4mz2Bcd3FgJBqZJcrSIbMgbU35qcOE=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.39.0"
      "sha256-GXdgWq/RsGfy4mt3PoBy1LGPuRFc7bEv3Y7FoaiJj+0=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.39.0"
      "sha256-d4XltwEWkumr4yMqob2Q8NPt6tHO6y2q1ldfyZNE+zE=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.39.0"
      "sha256-oaSZgcZnM8eQOGB2dUCldimiHAYFgxrv4viId0eMhPw=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.39.0"
      "sha256-vefBWZn9mgs4VxEXksQLE7PMue1VWRL8Pc9MWiLcu7U=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.39.0"
      "sha256-iNozoFOjdSojG1tVeEEkmTrpDRpaAP3xVPuCr8K4Wfs=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.39.0"
      "sha256-zabk0gq+BwsWW7PjED67ShfMmOusa+/DOk1SRkSNhiE=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.39.0"
      "sha256-QTIy6jkvtyRoScjRZekScq0rzH2f7mALPPuaN0LOy60=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.39.0"
      "sha256-JlK6LrTtu9bpGHID7JrQlLVIqsEtPAMdfD8/0AC5yNA=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.39.0"
      "sha256-+YjEeVVfxTjJVzwzcW9GjhGF/wuUjaymXkjRRdjSRqQ=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.39.0"
      "sha256-6RPu+uH9ClFg4flh9xZWt05buMewINjHnL/SyYDJ6fg=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.39.0"
      "sha256-qFFC4umjQvMHezgbAeMHniPmxhIJbmffpO0F2Abrbm4=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.39.0"
      "sha256-WJLxSFzxu8PFXqrsGn8iBySFabPMAsrFld2VJjFK0uY=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.39.0"
      "sha256-/FHnjne3cQ2ecEoPzJWNaoX/ACKlDIi0goGOwRn/1Ww=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.39.0"
      "sha256-SxRBlQAgb/WMhQlGrO7iVB6U/B5dYTlCuiPqKQmy5s4=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.39.0"
      "sha256-ON5Ql74yFx2z+QQQAYuQ7UA0HaV0QuE9EyzDzRM9O4k=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.39.0"
      "sha256-+aD+OSGdfESTitt5seSfhIeUvjvPkHafzdSBluciFUE=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.39.0"
      "sha256-B6mLiApULlnL+4JWQAz0uRaoCdK8A+J0gOrLCMfr8Hk=";
}
