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
    buildPythonPackage rec {
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
    buildMypyBoto3Package "accessanalyzer" "1.35.93"
      "sha256-A1jv/sqefllygXw/cEPoqdt1FxSfPDC81nB1T1rRxFY=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.35.93"
      "sha256-uXVkwD2G+QnXXVUCjDPV14mAX1xwH5mDLyjkYKpLynY=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.35.93"
      "sha256-SllB+K12txc2bVYaxPNHXtPyrB5ZDPZ2fnc+chz8+3I=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.35.93"
      "sha256-ldLdjR/fFcRmxSdgSNxgOm5KgmVnSAklGp54nFV/wB0=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.35.93"
      "sha256-GwhcnT4nocSIQVEUWOCnB2UicWoDVJagZNBaP10kum8=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.35.93"
      "sha256-Ey7AQZBFn97WigjvNVItFzeK/Vggy+XSG/2JITClDS0=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.35.93"
      "sha256-vB2rB33+OVEcp85vDnHJKMpNJA1pJPNm+Bmmc74Fdeg=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.35.93"
      "sha256-FvLDkoInt41SXEnOridW504y1rH+3ufySY92kQ6N+Ig=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.35.93"
      "sha256-35CVfF8sIZZj+CW5BctTufU/15guAbsh2mX1dXw9XUE=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.35.93"
      "sha256-SxHhqkSSsYy81ijsCIgcr3d8Phkb2OMGcHdHFf2axRU=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.35.93"
      "sha256-irD2ZVO1bR1YCOTKFgL0iMXko+qPvA5O3ScwXN3JY4Y=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.35.93"
      "sha256-Y42Rv/W7d3P9snGi2RlHFBshG4rXKcDdfd6aT+Hh5BI=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.35.93"
      "sha256-AQstsZhOA+NeIE1jEApuvA7KKmgw7wrFxgcC+A/9T/s=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.35.93"
      "sha256-/ekMdOmuCDwiEofsLZfxEAJbFJ1Ha9yuNppO9oyXeII=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.35.93"
      "sha256-TeHdsn/nA0/a7xZ/vSxE1vH1EBQqmRTCxgsgVRY6byg=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.35.93"
      "sha256-bRZE8ETO3bTglMYY+rv0UdgiduDtrkwO8E5gbuIlyNM=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.35.93"
      "sha256-+DZ2Q2dRCRRnXYAVC7paed5iPR5X99opMggMIajWbHY=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.35.93"
      "sha256-wwugoLJB2NTFGzFUxAzoHbIqF0y/gnGB+wZ4DDNQRE0=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.35.93"
      "sha256-cEuX4WsxR/wKAazTvg3syWsprq9lXKx1dTfPVlSHzZY=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.35.93"
      "sha256-qashwUSTuBBrMR+rZ85vBCDf8zSKk2vs/BzdMp7eTGc=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.35.93"
      "sha256-SvD67JfDwBxcZHleAvu3LZUjkTxzeIAkzjq5lySWDQ0=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.35.93"
      "sha256-7mr21wBmQQZe+I7GKnh4pHhbOzvbOLSjkawcFlObW9w=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.35.93"
      "sha256-I+7JVjqREY5Jy1VKDyKbPXSuV84WHWeCLqDxRIEMoUM=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.35.93"
      "sha256-A8uKdItOhZlXkw3wO3ezuyRs2U6XNRd1UZMp2DdLLI8=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.35.93"
      "sha256-+S13phyeCBsvIprneQUiafj88P6w0/QaEWgvGjv/O0w=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.35.93"
      "sha256-Cg/+XniDrn6QYnF420Cx5atdUSAlwzdg7W8mvDTMC8g=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.35.93"
      "sha256-vpRoMoTHz+O+cS8ck8uv2xG9ELSbNi0ODS0rUqp7XEE=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.35.93"
      "sha256-J9mt3ADrYWCw28Om7WXCKh88405LEvgHljQOEGWeaxE=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.35.93"
      "sha256-KNiZK3epkO0Y3IaCEYSOukpAs/vKbLxCG4EHBZHK5t8=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.35.93"
      "sha256-SBVHEKZyyNbdaGwofr3V8GT0aNYgv/HUpvYk35JJ2Os=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.35.93"
      "sha256-+SWNscjvrgHcXQrWvYhcOoWvWQw8VKzNAy3RBfHBgz4=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.35.93"
      "sha256-rgiehxhT/KZKwygbxnZ0xxm4JJqoOQZPznanGl9n1ok=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.35.93"
      "sha256-NQQzLz7LhzR3UtSJyqWNrczZvmbbNfOr+sWbdYt/oTk=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.35.93"
      "sha256-z4KxBiXTXrqJO7wY6uYhK7LTTPuxKAkcIw4L5i9XMro=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.35.93"
      "sha256-IrZtFEE74CBrk4NguFOfzKoEdF3LwhzD0bN7gQVVZkU=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.35.93"
      "sha256-4In+eE9SPN2i+6u65bSHAM/obrS4UjDpZuI0pr67Ebo=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.35.93"
      "sha256-GroBhtqmX+BAfei3OeHSv72p8jjaSnS5jUFz+v0+/XY=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.35.93"
      "sha256-YABv58UfAx5mpMuY9sHXUDdjCl9hYLcqjSzHOv0WWoc=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.35.93"
      "sha256-lUjaohooCpPrD422JOA6P4wmwa3V0hfmw7M8J+QDjZ0=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.35.93"
      "sha256-DT59Q7d0uRKwBr0Ye0kDYNNsP1XeQ57utrh0Jkism8I=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.35.93"
      "sha256-iGB1ZJxGJzknDUuTgq9MKTjmx/w54SfffTAJH+9Su8E=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.35.93"
      "sha256-euZArRjhxQnMAwLxZwWzQaDtkpsiJF8Pw5385qckBc8=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.35.93"
      "sha256-FGuKkndbaR7BsGYE7dWI+7W5N+N+7KTfe20ouX46jnI=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.35.93"
      "sha256-uA5REVn3ayNbn/RTQkW85b1GYfP0jaiFa++bndH7xUg=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.35.93"
      "sha256-4L1gVnCr81EuYDPMX1FvPKcyEP4IXqqPKs2GkJ3g2Hg=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.35.93"
      "sha256-V9wRL/Pi3cHp5iHkKEkLkEwNqMFTLTDp+ioZrv3p9xk=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.35.93"
      "sha256-Xpsi7anZNxPdooBO2CtfYUxw9HrSKo1kwTHOy2ZS3Mw=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.35.93"
      "sha256-4EYaL7nEbjypOOtEJwJvqLvXfS1D0zGzGSWY85XVzRQ=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.35.93"
      "sha256-zJpDczYBHPPgdJlFOjzS1RnHLDO3CuPid92S1CwjaxY=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.35.93"
      "sha256-kAKO2Q8sIwsZjopE1T9KS5c0Uzbw9/y5POTNtKVPfug=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.35.93"
      "sha256-S+z5x46d3GoQGALbixZP1YHn/EWARPP1tFBTQsLNSt0=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.35.93"
      "sha256-nuWEEkzYbP0Dxwr2ou7VBVUOH2Af/wqAb/Ob/1JoTEg=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.35.93"
      "sha256-TG5uda4z2zdHroCxDdkqAUad4tnKRAGbpUWruk9sI9U=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.35.93"
      "sha256-KvDCq372n0kDHnSHpOruHAYHmsi9CnqAtOkG2pSupJY=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.35.93"
      "sha256-00fCatU8SbuxQuw+VAbG1kOJ43asrbGbq8moJw1JzrY=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.35.93"
      "sha256-h2/TOx5T7U2iBfOZ6aDyykzEd0A/eiT/5/6fKS4wR1Q=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.35.93"
      "sha256-BiHeDNvtDwKjueF0Za16SuJ6dHlC2SMuHKlrtsXOvhw=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.35.93"
      "sha256-ZQeOiEchZanKwr+KeLXwPLEKHojkJsTDEN7ttDEBKEw=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.35.93"
      "sha256-ooWZ9Nl7Bfhg/bg+LVko325dhpQcyGk8a5faAFpOJOw=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.35.93"
      "sha256-nV12aRUnJ2Ot41DJXDzr8MKgL01/MW5vt4dBtb80PGI=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.35.93"
      "sha256-TAdgFTQw55CxcMYp7SRfa8w7cLcsvqiFNGnxlWXTz7M=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.35.93"
      "sha256-kAxqqTRfbZQeymVZSwwySYlwRKRzM7JisnCb6fDRagA=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.35.93"
      "sha256-HNwM5RpQx8kBZKLHRgYN2paYxRIOpb+Re+4ehzCaB7E=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.35.93"
      "sha256-DEwlCMMcTMZuz7BT8ZXl0jUQqwcUPobM8519UZacdsI=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.35.93"
      "sha256-Wh6cgsXiPlfVpFHgf3lFKepX1m1yMQRD8d3hsDb8GOI=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.35.93"
      "sha256-uzyc1smPt146YcgC+o+5h0ovUe3Xya6pS/cSdBrvfyg=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.35.93"
      "sha256-pBthYf0gWMd6vIx8wC/O08yUvanrlpnMqh0iIbixv+c=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.35.93"
      "sha256-rlEDXCfukOfvOC2vKXi0OQdg1le8SCqVaMsbQVr/lBw=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.35.93"
      "sha256-nPe+bhlrOF6PJ3AQqDQWODSg280HaVPu0hvfsXNI89A=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.35.93"
      "sha256-zBPL1DFdMYELOa3YMMlsUL+j6aDTNcYtAMlTlvkLnF0=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.35.93"
      "sha256-hln7MWYK6yPqN77pwGz+013kHyjXgL4xFMycUzJgMMo=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.35.93"
      "sha256-Vk1dvl/ZLf3vkTPa/Zt/tzoGZvS+FuKOQ7HgjO4Df3I=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.35.93"
      "sha256-C7YkZh3bwcYEDIs/XFDG7ICV0Yf6jOmr9krvX4sw4lU=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.35.93"
      "sha256-gm0RNlhpNOq3SvRuV+LSfIfxsJR0vxBVdA7QleeSnTQ=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.35.93"
      "sha256-skf84YWmj9M3EF5dr517QOVEIrBid2ofGQSQ89qkUVw=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.35.93"
      "sha256-M7WZ6bqF3NFL2se8gtcLX76HMbNp5SmyXUQ5nrgq4qs=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.35.93"
      "sha256-vmrJspLRVKddWxhpQym2qJR5JD+wR8Dw5GdPe+IWTq0=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.35.93"
      "sha256-p7BE0t5beOVGZaoyV5BhS6V0GkCB6RsyuzfW4D0VWac=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.35.93"
      "sha256-iqIQ7iybLn0U+WAvB5S7wOKcQMIJKx6KzqXxgPFtZwY=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.35.93"
      "sha256-pmN86a8XGrbvcZFRfN95r1cCPWiKQZAs49jraA3hPqw=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.35.93"
      "sha256-vxrFxJfdRMbsi9B25Z8b6FPT4pa/Vz7Ypf+k//yvu8w=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.35.93"
      "sha256-tJkn4iNC17A61oW3wDo92dmmF8IOoZdsPsaTFAG2nXM=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.35.93"
      "sha256-6UJ4trMNIQkmR7YL5x6npJzIJsLAv3mxjCB0ckdBSiM=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.35.93"
      "sha256-IeDITSDfFXJYBR5arDQ+qsV6UDZICqwTpSozKiUrP8o=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.35.93"
      "sha256-2e9ifFDRAPkJye4XKGU6r0eTm1JLbz5QXbYZvcdFTKw=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.35.93"
      "sha256-TxBjqeQUbqqdH7BS0DZNkSlyIVWrj+W/9LRR0Aio3EM=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.35.93"
      "sha256-mVRze/oZtzSiLY66ML73hcU2d8Y5PfRp0beuT9jsdeU=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.35.93"
      "sha256-TAnzoDMzgR3U2Z/d5rbkIPXq4+mKAdLp1MI/K+ZbacM=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.35.93"
      "sha256-NpQ5uL3uYz5HKe4n6UkqTAF3drh56jllar1jZ3lpr/M=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.35.93"
      "sha256-6UZfPwkn7gLgMDGemllv2KuF+LrT9rVC/8teihR83iE=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.35.93"
      "sha256-BW3/1VKXUHWzqnTHC/CjI8L0hbSqknGyeMGH68emHOI=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.35.93"
      "sha256-vCQ26WL9DZ+T7N9ijybR0ICLWkjbUuEFU7LySaqeyoE=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.35.93"
      "sha256-r1ZwXIZwU3QRQQGVXGKBukgjeuNko/IaAVR6lJEBD28=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.35.93"
      "sha256-gm4aGzwRpoavJOEtuelv9qoEL+usHtI3ziOvthwLwcg=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.35.93"
      "sha256-DS2dkeWCnaC13YGVLE4CohHLEi4/b6Ljf9GLQb0pmoM=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.35.93"
      "sha256-EZfK4RgPD0RWYqSbOu3IJX7oXN9QG8G46MFwFV09gyk=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.35.93"
      "sha256-yrTXfvYfk7w6lRnLMlUmizQ75iOHrSLgg1pjPLmxaY0=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.35.93"
      "sha256-DI0I+/bHWzuatdboUY4QahAqbB0Dx+tNMkgTaSLGq0w=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.35.93"
      "sha256-wBlz4YrLaKwcv7O1DkInNhq7Hg79vBTr4PGeECHBLPY=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.35.93"
      "sha256-BPsvnQKZJvcnN7PVLqUF2zpWZ5n4lGgu8XZBHNnxmIA=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.35.93"
      "sha256-vdlq5ewSsDr0q4bjA3DlJsmT4GQANhWqu3HEJapOQJs=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.35.93"
      "sha256-VylacqlHO4VCV4qxXrCkkJytbyzuHaQc5qikCrcFFDg=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.35.93"
      "sha256-xSFoglHnKIBO4lJ3VzhnDKB/+Hrbz5DWi6ps2lg5yDk=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.35.93"
      "sha256-iJRvAr7/y21Gn+f1YiQO/OwlIxFXdvswltqQIOC87Po=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.35.93"
      "sha256-0BCzjicVUMxYPI9rEdnzZyy9dXe1I0CtxrKcuO0WgMU=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.35.93"
      "sha256-0gBpLaLg+V5x8HJ+dBZ2DpfMKZZYoYZ0u//6Za4baKE=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.35.93"
      "sha256-phN845f+U9lrdyPbxOrN4MBfgS4MV4R3ASlEzcXCiGI=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.35.93"
      "sha256-/nskeOmBVrczk1wmm4DF0nusaxd+6Tk1/dZOpTVYqLI=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.35.93"
      "sha256-PfroS1SO/d05OC1I3rNapP+jD6w0LQjI0xWIZMHWuPU=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.35.93"
      "sha256-Ej4Z1hmVmtMWTFQ4zhNh7WLQks53ZBofOJTVt0X19g0=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.35.93"
      "sha256-7oRbGhNoJTA0S3zufRbjdp1thBd1lEWb14jn36eVZ8g=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.35.93"
      "sha256-YR2AtGkB684XznIdxKs542Qo4dVrNMRbO9t+Uj32/RQ=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.35.93"
      "sha256-tMw3BpZw/QAuZt1nmWhUNSPAoMkbFh61cH1SyYdWmZk=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.35.93"
      "sha256-5fb7H16VXRCF7S43QOzQmh26jMAHVqhQlKv3/jU7Et4=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.35.93"
      "sha256-lStH2oTjt3MxuqohMC+oHb5t1//CX91yHYWjNpfp0N8=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.35.93"
      "sha256-EyjVSjrqmuOFigajarcB/+Ys12rfkaiG0weAVeBwXzk=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.35.93"
      "sha256-IbkdLlg/P31VLEO4Btd331MCHqrMAnfoISiCj96isbQ=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.35.93"
      "sha256-3pA8DNLLbqcYe9gtR+8epkgd1hv0gMYOZ8qggEEyTpM=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.35.93"
      "sha256-ou+2f1pu6s8+TZEN0qzK6vbirxQAikqSmrbUJvQKRT0=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.35.93"
      "sha256-FLmt2YJMm7oV+XK3Zk0A6cxDu3rW3UcXzLq1JWWIWts=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.35.93"
      "sha256-Fgg1r71NWgky9cFFSsR5JmZCoaySJIE9sP6xiYWnw4Y=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.35.93"
      "sha256-qIz0jMQYpQ0N0EcjDOGRzD0bqPeLVaJq0dzT7/xH9jA=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.35.93"
      "sha256-jBVQYYUjnU8wbXW3XFSFCb/gnDOqkTgiAx8NCHN82tM=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.35.93"
      "sha256-V6LNqtede9jv8nsF8FYfTAAC0S9qapucnbG521nPyYM=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.35.93"
      "sha256-9nI7HTgR3UkryYoHbO6njO9t01Vd6LmwoN4rmAyT7tg=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.35.93"
      "sha256-SVPMc6BHrhZeyOR2iUo2EZ6O9Yk4zGgpp6ei2OlFfDQ=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.35.93"
      "sha256-50OikIHDj1ehdSVQAdzhKz+EzS1E1AeyIM/cXd5/XXg=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.35.93"
      "sha256-NlmJgjTeCSSoQByq4vF2/4zuZ+4L6SQ8ORV0LtzNwq8=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.35.93"
      "sha256-QU4Nz2KaB43qJuRTc56hPYXgURyhUSS9vR1KmB26RXI=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.35.93"
      "sha256-7Mv0+Cu/6tq5eQnDEQZE4jWO7PrUMIaetq+6t/aN5nw=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.35.93"
      "sha256-Vyx6ki0OtFy7nnTm0DxEYvFaGfRkK0YYty/cCLU5TM4=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.35.93"
      "sha256-J3Wag/+lQUslidqDYlgWo8fLl2AP7GhXi9MBKpriDug=";

  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.35.93"
      "sha256-o0/B9yPZKyiggMUJYLgaJuoeK61jmpadsMGRRSE/RZU=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.35.93"
      "sha256-aGXxwcBZ8A1OL1QmG9CqWQKlH6QkqjVxlEk6XQaVPAA=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.35.93"
      "sha256-InQ8WIxTkSixj8nEJZ0Qghs9MJ8i6QzfoTaU5ZGmx4k=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.35.93"
      "sha256-4Ybro/al/yjNUZJzKtrC8mzat9VjGb5LqGDPzrMeOz0=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.35.93"
      "sha256-ogD3HW2MDtzMhhVLG12EVZp/F/b9JrEGJqBrTLGSTAE=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.35.93"
      "sha256-OL5BSCSNNdu0l572Ql1Ayn5jASHurvhVnQUjIS5DTXQ=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.35.93"
      "sha256-sgIVxItk/Ow4BiLdbx2PMkRipTdULxX64pp/ixZbrgI=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.35.93"
      "sha256-JZXI2sQG5Odx07fXg1+qy5NtIESbnN0XpT8HYhnMdxI=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.35.93"
      "sha256-qSuSaVpjEzdjr9vwH74IibWAiiiQRkXqn+wKWWTU+u0=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.35.93"
      "sha256-Viw56d3d1j/V7zijdxziCh/0E8vy1oZwE7+AhP7Vwx4=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.35.93"
      "sha256-sS+E55GkpEaO/lixkQZulvX7OWjOY9p4L2ysKNvqXKg=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.35.93"
      "sha256-R4ksUkE7JINvc0PdAn/CBIMCUPH7eJV1zBjhZryuVcg=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.35.93"
      "sha256-6I+sYTmbs7HGF+1SFFAYCQorQ91mvWFJTvgygVp4oUo=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.35.93"
      "sha256-EI/Gl6Cto8hVh8TpnfMh6GqTyp4V9yVa9bDKW86GO2E=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.35.93"
      "sha256-ZLs86Cx10TPy3HflnOAv02VItU/uWLyesGYkyAF6JvI=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.35.93"
      "sha256-5kw/Vw97r9HjFtSnD/eE+qT93S3f2P2ctvAB1A6CMMc=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.35.93"
      "sha256-wickduc7XoSsCc/8H/7POat2CYEeeW/GcxG9dJql05Q=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.35.93"
      "sha256-ycY1Gz0SaU7AbyMwnHKBHYF9J4luwlKHPsCgGIDzpJc=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.35.93"
      "sha256-poktyeSfAizee/UbmnyvgkKOMN4PKtnlnJWYuIbmQmk=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.35.93"
      "sha256-vr/U3mjDol42+heZBKgAGcCoy4RLOK5wUauflCXl418=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.35.93"
      "sha256-nnyrY0rtVmggFBCvNqmVbb5IiAorhZRAewwyXVkjMt0=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.35.93"
      "sha256-73bCQen8CzXszpG06nSCATt2lHOT1E8V8PUg0XLMqY8=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.35.93"
      "sha256-jNykp2IjsC3JPjwodn/xmvJz6fTMOrIr/ijcefUZBmw=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.35.93.post1"
      "sha256-LmKNUXOP8tsoajo3t9H2x/TJBNo8z6SsyTjn4tDp82Q=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.35.93"
      "sha256-d1Lhj2/izhVGJiIP37NhMEvz/RMzWuw6NpFskWoN7FA=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.35.93"
      "sha256-pDRu3al9uBr5wkEcMmOVRr3Ops7pPs6XN7rmy2ZCcxQ=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.35.93"
      "sha256-IwnLmn0a+hofj7tf1Dhv4ybtwa7IerTmrEV9iu6qNmM=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.35.93"
      "sha256-uKdd8g53jc6CC9ctrH+JcYhLBN2Me2qGueuimF9imE0=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.35.93"
      "sha256-fcn9TZwSyut4VKJPzuAPxaK8GzR0MnnK9+9W3EZ01JQ=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.35.93"
      "sha256-6vqX+gkajl6N4EPusz9DwDCHDfswMH4/f13afD33x2A=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.35.93"
      "sha256-z09uzdTF4r8hPciAJ7gTyMaJ60CFqfMD+JajtNwP1yc=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.35.93"
      "sha256-i1vARhAsw7mXRBVMVicEgz+7hHWTdjqyF5qf+QVXjCI=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.35.93"
      "sha256-+BthrsgeHHKf6O6CWsi9CaxA3HW+DY0BGIc7uACnJTQ=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.35.93"
      "sha256-sDDmDAjKRUgm9G9SFIbMxHO9BDPuRSDerfP4H6nEq1A=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.35.93"
      "sha256-sION3AXWCJXN1nz0nfnvhTsXX1w6FhHHhRTkyC6jv9g=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.35.93"
      "sha256-BSXcQOv0yAYNw64fClbZbaR4JME9ERIY2+RZuefs2hg=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.35.93"
      "sha256-8HGPW1S5VXYXkLSzO9yrjQx3m9UMxnHGhiqOBVRRW9o=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.35.93"
      "sha256-HdL3FbTVYAXKpM7VW0NXqpgmeGg8P0Ug/+Li5Hj8A1o=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.35.93"
      "sha256-+g6VfYlaiV/bFXdn79rQ5j9f+ijg+dvwFz0Gg2F6taQ=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.35.93"
      "sha256-DWWQfygar1pwQUYol3ZvBHr5nbBIeFJQM384CBHnfP0=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.35.93"
      "sha256-sR1ZRhrSVR5vka4snBaoMu7vCrux/2jI8IN1rdZSP40=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.35.93"
      "sha256-jKiNeL0ACrDyJ5UsveTG+xZFs4jUE1HCCp/xCecBqNU=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.35.93"
      "sha256-4AzUzHV5NXUfw+YzClZtJSdxDyT4gk/yzvW8E0odz0w=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.35.93"
      "sha256-+o1vQSZKwVa24qyItKjoXI3TFlVCkYF+wJIR9/2uTco=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.35.93"
      "sha256-kpNhOUiGzGZoqyTqUl0IlHoNSco60uttn9PC6LRi86Y=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.35.93"
      "sha256-asICrCujW0F1DFVrUB0Mwjvk17vqZj9VIGkLK4Mu8Kw=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.35.93"
      "sha256-wRsEd0PHY16oOFq/+vl3iKEItxR5YS6bXn0LsZAp16Q=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.35.93"
      "sha256-vR6J868Gl3YoKWqGmiiBLEDbLi6edfseGSjF0LPWYgg=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.35.93"
      "sha256-RiGbnx07ErTP/kHDrudTrNinaDMt/1bkb+tDpQPD+Do=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.35.93"
      "sha256-uemBDjrzUGaEq7T8te/ka7xwpkPhix2On47DHZWyiLE=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.35.93"
      "sha256-b3A2qdC2aR1Z1/o1DnhA4DNxyy0IhQLFoGw8iurraEQ=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.35.93"
      "sha256-8BhNvneehbL5gT/xqXKCXtgbQuHYd5W7QdXc1g6UXgY=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.35.93"
      "sha256-vWkI8O+7gypV32xfKa03p1u2afSlRsjiJG8CxFHkPvs=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.35.93"
      "sha256-F4lbO1pB10yQ7XWCiWOjq5nm8mofhwMsbKBUd9kM5xw=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.35.93"
      "sha256-dMsQ4O20MVGb4akSZA3KWTIN3cLKPM0Ef5mjJ2Ct4x8=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.35.93"
      "sha256-qTy3TrRLg8hDgPBb4YXpvaWcZu8o7QNUS4iM3KCc9Ow=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.35.93"
      "sha256-jvJiTj2EZpUygYK2R6hvhfy0p4ZA7RX3FnCfkGIqNps=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.35.93"
      "sha256-rpkFqQY36GYHEOXXiygCUYjq9ikrYNhVktCcIDC/gVo=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.35.93"
      "sha256-1NiLAfb72oyHmnidK6XxJwq3Rr7MCAVwKufnXsho+rY=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.35.93"
      "sha256-COSy+dty349kKHZ9eN9C2C64KiNdMCmSZPNVtzptG/M=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.35.93"
      "sha256-V4pIgRkTseN9FR0XLIw1lDMTk94QsVlZRlkr20h0in8=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.35.0"
      "sha256-TNj5R4DxrKdlOa5u7O9gNwkzMkLPP1mcxYyu3bbONgY=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.35.86"
      "sha256-l+feBRISmdjgXQOapMx3ZJRpi/Tg44zr6F3+GYvOpeg=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.35.0"
      "sha256-q1fKZi0acgBXZ1Rvugvl0iwdapObzDsZnhRlTS1bShc=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.35.0"
      "sha256-WaFRp1G7BeKwm6g4rAWmf5OxoETzwit8YlN3R5hazuQ=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.35.0"
      "sha256-RXCmmjnGhMm6+EiYRGhlHgkgcftZardnyOBWaq5eQ0s=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.35.0"
      "sha256-fVtsD81DbUIsAtsfAeR9QC9NfjKV4fAswGpleBfHJMk=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.35.0"
      "sha256-POYl0YUu3WsZ9lfseKTNuT6PaOVDfvKbqtKM064Ksak=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.35.91"
      "sha256-uMaBmD14rqFMZ7KJw5cn6JkcY/4a39oPyWJBatQPIiY=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.35.91"
      "sha256-G1l3yWroXYQRgWgMQ6MZ/AXrarn1KXnVVMbTg4t62sw=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.35.85"
      "sha256-KQxCwCHvc/1JrpEaZRTW51svxbTYZhq971AA5gYjO84=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.35.0"
      "sha256-a3ToXuhOWn4H6yEf77XWFRpG1QOFWn3tuBzj5MV3HZM=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.35.0"
      "sha256-ur1A0iPMGgfI0XNSOiXX4VF5nR6XJcnpk0KM62Ujp/0=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.35.66"
      "sha256-sG9IY1p72flgZY8JvyB7GdhT8WR6FUHpg6Lq8cEDzo0=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.35.0"
      "sha256-iQi2/pE6ojnp6jWtkzWD7T11dxST+UYbETnUjEH0r2E=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.35.0"
      "sha256-pOvrDLzo9rXF8CHLX6OL0gwjWW+EklFQ/B635zcm828=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.35.0"
      "sha256-mECUsZiuYN9O4WvUdu5Ge/WsFLEKhxLnD9WBpxZvKTc=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.35.0"
      "sha256-u+GgBEtw2AVonu+XqL8gDIJig9foiUufz1++qmrfx00=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.35.72"
      "sha256-idcq48WzunZVghmxe/LJ/gdVDg0jZD+7aofYlu2nCdM=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.35.0"
      "sha256-qFXZE2y5MSpOZMSKhFEeriXHgbboQigOufmTqbArmns=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.35.79"
      "sha256-GRQEcgUhnpri/waIMhJG9ez5bppRI4o2cvLQAvTN408=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.35.0"
      "sha256-sbnfx714qwWSTOgf/ptxpV55wdTa47yfNgkOtu/BpDc=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.35.0"
      "sha256-HARwGwot9kfEvVJwk5c0sjeLEcq/jAhh+2kRBUDDdPw=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.35.0"
      "sha256-j5Lw7w2lzVJAsR69yMsccEV0WStBBhR/EdR62suDJ1o=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.35.0"
      "sha256-TMOu+TzMU3qQn8upnPKYinhToe3cW5fKbxEXj0QGl7w=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.35.0"
      "sha256-uzkFo1wOgpLdpSI2ErtfRo0uTdY/XbYltubzg4kC5ro=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.35.0"
      "sha256-WusbzKkon1Ep+639LtHqwcLRXvtSLeSaSXdAYTm4gmc=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.35.0"
      "sha256-iYVnkwqOe0UMOqI1NcD58Ej3Bk84adPWC3yq7/+3x8I=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.35.84"
      "sha256-HnTwgp/5ZRKHt2CIA0GpgyRe0BTiZgoRr1lrIvdqssQ=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.35.24"
      "sha256-2hgamfnf5SPWo8R15FWJHO37IC0y2oLDTHsb/oPjArE=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.35.0"
      "sha256-Epx+p5M+3x0plFaXdc8Rsz+p18ZnxbNlr4IhH5STvZM=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.35.88"
      "sha256-36FYuBsY8ZQ6o+T7U2zZclhHPvIRbeLby9oSJyshxa4=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.35.81"
      "sha256-QNLa/5+ql3ItgVnZo9no/HiRHOUOhQFkADsc7cZTz+0=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.35.0"
      "sha256-jHEgFpoHJmep4Lv+ge3DSDthO6d9zt23lWBp0MztcHQ=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.35.68"
      "sha256-/IGDrv1Yyk0eeDfdQTVkxhrANPPCqnfjatSRItkGWRM=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.35.72"
      "sha256-gk+hOc05mEusC1o3pQaRvIDXJR3sPc5W2Af7l1SL1sk=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.35.52"
      "sha256-d7SehQ8mnD17WsZhucdKnEE2v+sI/cdoaMhYCBkj7nY=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.35.0"
      "sha256-SkQUH/vYdyq+YvCfqZlC4hwxirn7JvPwxBVg/Z17M0A=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.35.0"
      "sha256-qyUZN9Gz8Q6TBDg1LW+M58TLwDlmqJ9aCr4021LbSL0=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.35.91"
      "sha256-qSL4m1GfSbdh7EKObfWOh6YP/zzkTxtH7Qk7+R+NhBc=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.35.0"
      "sha256-PdOH3KaQn9d455qCR565qFlyCb8t7R8x8wXBebHgtt8=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.35.86"
      "sha256-mVk6bISwtgYWyImotFnHTOBtvxSgRqIbWh9wJDJ5gdQ=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.35.0"
      "sha256-HFjrSRkc3cEqImMkqC4V/lfk/ArD9/2swrK7xo9Hut4=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.35.59"
      "sha256-WrQdJntSi1l0jLTGdx0icfUn6VLOn543GDz8WxX7h9k=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.35.45"
      "sha256-9FxAmPtuL14Y18X05pMj3uPoJqAyHJAJLDmGgoU79uY=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.35.0"
      "sha256-xIWR2C4YbVpSDhZesWi0IUJbR/eaH6Ej3/EREAfSP9o=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.35.9"
      "sha256-Z10I4CW8XudCHhEr1ccnuf49EFdiZNAwaZi+EJDmArY=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.35.0"
      "sha256-F9RA+t49GTchoKXlZTuUAlfUj/23ZwH/jlm5GqTbhLg=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.35.0"
      "sha256-mz35kZg6nuxkIqwPuNRmiFK0HX+VRo0l9SzJ0tJ1s50=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.35.0"
      "sha256-VpDsWrHlAD1KT29S8X/vAMRbfqS7dg+koPXEOBHYG/o=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.35.0"
      "sha256-iNYUjASrJsgEA5fGa8J4H37lzWHXdDHIi+1dRdJxfkc=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.35.0"
      "sha256-cLs9DwibD7GB546pEd8Zx/Xx5ki2tKYc8drFEetNh48=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.35.0"
      "sha256-AYfD/JY1//vPw1obZAmwqW3NYwSpqg1zjQqTpIk80Rw=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.35.63"
      "sha256-5JtwFqTutitSEnHyXpb/m3O/GxZg3uO4Y0DESGF5g/E=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.35.43"
      "sha256-ue5t9EUm1PKFCCwkAq2A1CRl3rWFuo5IhrG0SHddUWk=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.35.7"
      "sha256-aIKpT15gBmM2gkkSbmzs5pVvAIfessdzlQTspmvK+LQ=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.35.30"
      "sha256-THSL/TxygrV/E4XO4YQQBS5p2xU7MyPFdR2ZkVx2o0k=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.35.0"
      "sha256-TdWk5wgJ8DVwLgTUGto9wrXaTdFZ4LNG2uxahFkYeKo=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.35.0"
      "sha256-zhkzENeWyzHsJVqEHa1iJzikaC8zsz1Yu1Bud/zNp7A=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.35.0"
      "sha256-SgDXUGMc0VwsKcGLtUGA565c4uDy4BhGcW6TIVP8988=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.35.0"
      "sha256-mtpp+ro3b7tOrN4TrWr8BjLzaPo264ty8Sng6wtciMs=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.35.84"
      "sha256-tC2WL64QqIniBdEB+OiFmDHgmRvgAcaBUMz0Qb8yuG8=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.35.0"
      "sha256-kwKCaPtSl9xFVw0cTDbveXOFs5r7YzowGfceDSo+qnc=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.35.66"
      "sha256-12AIEWhTwK3YdCUhImozJeO83Ye9G2D1VaKMeqbV/pE=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.35.89"
      "sha256-1Xf5cjgBurcHiwvgEQCdv3Ry9sxhGLoE2DIXwcyJCgw=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.35.64"
      "sha256-wYdJOvvjN2biCMEBeFD87mqomOitaGQdiiB6b5Yiji4=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.35.74"
      "sha256-o2WegSdOLShXqAMNLc2IMciRRBZb60OlcYmIwSWq9Cs=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.35.51"
      "sha256-wCF9VqKH8GBgmKHsJZfAbNefu/zLw2piSJpuOaQ4nMo=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.35.74"
      "sha256-fxEje2HyutoB7Js++GxMnfqEhceCr2CWfbPpGrY2IM0=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.35.0"
      "sha256-mG3TeywuB5+87Z3nhqjFwf0y2WO49oETPMz+oL0LbOA=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.35.84"
      "sha256-leon3B/f0Z6DT39JFTEsxXm2lztigNTzgkAr742XVjo=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.35.56"
      "sha256-b6H2qsCgpX9j7yWWtPTV2CcPbtXit4HLaCH8YwAJH1A=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.35.30"
      "sha256-f+4F+0VuLAmx+3+qBwNj8jit9DYC/Dfrhd5/L0ledW4=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.35.0"
      "sha256-3DVLn61w42L8qwyQB1WbOPjOZXqXalLZ9rITcmcDkQI=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.35.39"
      "sha256-kh/KojcYdBfGA7BRorshz34R/Lx8e/WTa0kWpW78PcY=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.35.0"
      "sha256-Ss85x4OJ+RtOmP7LzIIMcikxjMvMyi3VUT9WLvxODSM=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.35.52"
      "sha256-O6P/xxxzAxBhmm5MTsK162moBRno/EhdUvrF12ZQR18=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.35.0"
      "sha256-G4Rh+i27qcxmB3vK+CfOhseC9Etso3Vs6Kt9x6hBrDA=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.35.0"
      "sha256-ofD5Ho5hI9wFujM4fR258i8XtFUJGiouGKErQEOzpkI=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.35.0"
      "sha256-n4arbk3VN6P/7abnM5yhgOQFdLJwioOdyx2ILcc6Mag=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.35.92"
      "sha256-5zgrNM8ZEJ/vtpeFrsJwpX6tfIZhPp1IpIJBJpI12IQ=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.35.63"
      "sha256-zKEDuWjd3Uh7QEFfz/1NUW8JAwhapDBAiXzAuPLXb/c=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.35.0"
      "sha256-RwPNNFntNChLqbr86wd1bwp6OqWvs3oj3V+4X71J3Hw=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.35.92"
      "sha256-msiNwPbYeJI0TtmbHloohCFVA6//OFlBe2AQsx3nzvY=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.35.73"
      "sha256-FITxvFeoOEHAVVYyyC1xnjkj5lks74SEOT1YWltMliI=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.35.0"
      "sha256-P2Yg3qvcdAcjY+uwPg2DpTgT6ZXb1XYCOeu4bVfgFKI=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.35.91"
      "sha256-lsSJGfbgQ0CQNbg1pq0JZYwZFkkHGrOQBekl2mXuSTM=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.35.0"
      "sha256-UThrKjwdje3TF/p8TXfAbKiTTCU3/5wVS4TWqipAeaU=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.35.0"
      "sha256-+1rI1wBBp2sNpSyxG0dMGhz/8B5nGSx4W3ITbVfPuf8=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.35.0"
      "sha256-eAjvYeqZMeNRz7iLCM4gXixaIWbgdv4u/w3BDeoCvmw=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.35.0"
      "sha256-ES0cThhoMFB4NKVTzThXATiicjq+MTRunsDCMC6YPbI=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.35.24"
      "sha256-WBwXrGv877AZv6wIxYGwFNTVofmcmTqv/hqXAcraDyQ=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.35.15"
      "sha256-2afZNIvBO29vNemskWbxx9X1PqL7j2knxHUSEap6lp4=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.35.0"
      "sha256-u7RvDLzY2r6bnnfR9xN5qGnnqlGmDwH/GUZTU90/+YE=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.35.0"
      "sha256-E3hmY8JtrkoLrIgiM47JnzPrS5jnmG+oG9bDrlh5mBg=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.35.0"
      "sha256-pjy/HFGJ4pY4t/FSI1fbCAv9meFCEQoG32GStdaPDcg=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.35.0"
      "sha256-87wPEWSMc083Rn1+lvADZJVeuoN82A+foWetNnIzMBY=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.35.0"
      "sha256-w30YExW6ENhUaHIwTX8mbnRhQpsI5jUHwjzFCMPvQmQ=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.35.88"
      "sha256-s6qkdIPIwD4GUowrwg11EvyQu5rc9TBHXmkzPoxCE9Y=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.35.40"
      "sha256-w0Usj5BpCAYbX6/0uNoIqH3EBd8fgru4RwQHuF2OEyQ=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.35.0"
      "sha256-AzO2GU4SZs0rBg4R5bsajAX5dAJH3OFiHw1X1UDg5b0=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.35.0"
      "sha256-yhSUu8Rf27PHTYsbcz3oQ/APUx0ECKTwbzEOaYMZ/1k=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.35.0"
      "sha256-GnuDqVaAnWFGFLylpvYxtaL8yUlRxVu6jKB2QhSGeTI=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.35.0"
      "sha256-7133sb2IoSsgQIk48MLOL69Gc0G3BCqOlGXlpiC6TaM=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.35.81"
      "sha256-xhsK5KYSWA+B7oKDlnqWUMsWYs8xQRrj29ZjjQVSOtA=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.35.68"
      "sha256-VwamgC2lBBnVvwd80PAK09mAGNgfjoyrOP+YccxlAEw=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.35.79"
      "sha256-J7sAvAwJ9qvXqXUqsATtqCoPwsYmj9vJIESK0Qg/RsE=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.35.0"
      "sha256-cCYQ7ixo2v3kP3+cpvaIhLoJ0ErTfyv/XfBJZnovMjo=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.35.0"
      "sha256-BmU7vCuS8Ow5DSYi4qbLrYoZGsdYwh4IA9EVHNGMgjI=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.35.0"
      "sha256-CT7Xv0u/xY36/SnJuC3f0396G3TwNdtY0w/cL+w/N2Q=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.35.0"
      "sha256-ZNICMrB+oc/gPikX2R9WNKAOoiywMTzkRvlRh/P4bQA=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.35.0"
      "sha256-zDjnBLKg9MI/E1mSLT2Jb9mjShmcreCxHA1rhpC3UQ0=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.35.0"
      "sha256-qUIwQPj564EnKNxz/hpEoE/Ai1VNXeKB9zOZh5mrOHQ=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.35.0"
      "sha256-H1axrr9JdiGzMu+GugTv16V5A5w9GpJmdHDTBE0obDs=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.35.68"
      "sha256-Wn3vcHrCmMMS4LcTQhzctYPg2ZPSF7SBgQSz44bJyGo=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.35.91"
      "sha256-AS3ntE4BNwg+L1y0m2PAUJHRQcMrVptGnf6qXqI9HM0=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.35.67"
      "sha256-2rgIDgA+Y7HY35B4absPFgiuUcNe/dqixruD40uIkag=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.35.0"
      "sha256-0X0GgJ9dQr20jgQXNg9f4ulETPVHEQYaAs7+KxxIo/g=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.35.0"
      "sha256-sMJnd2csYnc0MxS36LdvHuvmYax+zEKWLiSRMNMzV8o=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.35.85"
      "sha256-tJsviLQ9oCvDfIp5+KZF/CGwmuhlhVIf6EsEdDNdqJU=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.35.0"
      "sha256-GQGf654mGic7mXbPb0PEAMytnkau/LbOWzoZRRNCt+k=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.35.0"
      "sha256-RPWIx+TuWRPkfN/a1S6/t/I+H6WFbWudA6mkgCC6vr8=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.35.0"
      "sha256-aTKMQz0w0d0WOWHGU3HIqSb3z6PvbuSqtX+saBIIRog=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.35.68"
      "sha256-Sr7w0zlGPr5hKDb0IVSgkule7QJbrKmhW+EobMmpBDQ=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.35.50"
      "sha256-60qxUQtbi+Dl2osn7zkSmpTuXf8DjTKDa3XXVsJynKE=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.35.61"
      "sha256-N0ZbodMgLNObUIw0aVX5paJZcHEwB5Glacu8KterTdE=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.35.0"
      "sha256-SLGLKpeq8kficWOg7if8IdTHuWLhe76Wn+72g7Ym8Tw=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.35.0"
      "sha256-DtF++oBv7Jb7yXY2ymC/KsQDgMPqWJWP3MZQOlx/NXM=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.35.0"
      "sha256-72VjJGOWAphFUZfMxzSaYyycUtoL1St08G/SAEhDriQ=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.35.83"
      "sha256-RtUDIylbrfzTnTNu+23QxE9yVlB5KVxiEOeSfZm4rww=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.35.0"
      "sha256-i0NmNRPwEypr4m0vNtJDXHEAbCcqdxTexY3MDaltvh8=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.35.66"
      "sha256-al4vTjuFg1CNtQ0u35zNsDPafgyAlNwTMLBfmlA/5Kk=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.35.0"
      "sha256-kDRm9b1g1M9qaiA8CDZLNBrGxw1os1c1giwDc+CpFxA=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.35.0"
      "sha256-ZZ/BGdnThJpysJGlKxPyTWyP6IdOhtf7PfjiBSYVg/8=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.35.0"
      "sha256-pRyowqpW9cqiZe0aCDvcJAqIaRkEhG8DFRxP89daIPo=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.35.84"
      "sha256-T0ezy1Tea/pMqnv6Xo+LswIrQUfcijKY0z6y6xH294g=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.35.0"
      "sha256-j9ZU1UHzKNo1+gb+uUYiMTIwjGi9OEg0jAmKGx+mGno=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.35.55"
      "sha256-ptQXmGLaWRtOqAL3iunKubP5gQHHAezQAubG3Z3m6BI=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.35.0"
      "sha256-mxpiis9WGSEclfaHOxFJxGIAO42R2c5zc58xQo4MOn0=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.35.72"
      "sha256-+lBkc6lWYMQU8six/6cPy1+J0ACZ0a3JL/VW7O98Qtk=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.35.0"
      "sha256-KeoPZIXTGHoS69QR5y4y3N4AVlscQ6Cqlbg+6H3MIu4=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.35.0"
      "sha256-rqjBKxMMg/gkt9PJyFyE3g2msAiTtiMZWF4TY3/grcs=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.35.45"
      "sha256-Soz9RxhGf4ss41NLcVT0UUjRcPv0sKzjcx1bo5MLC44=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.35.0"
      "sha256-3s7RVd51W47/QhDdYe7GmhPy/NZtGXp3RSNZZsNh0H0=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.35.0"
      "sha256-HoIUtkfoV5prtgdD7KOcxJnFb08cGqcJywdgO39s6zM=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.35.0"
      "sha256-q19sL/CSFtahdAO9srUHTsKBxXlp7w25rWHY8ZzpnJY=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.35.52"
      "sha256-bYfSCYypmTs/NVbLtazSZBgWWotLl+t0B7vm1tdaiZI=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.35.0"
      "sha256-Om/TFPBZh3xr0inpGzCpvTNij9DTPq8dV1ikX8g4YtE=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.35.85"
      "sha256-AIYAC98As8DWTYfYvSUNb4Sz47xsTmnw/EizUEDsJfM=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.35.66"
      "sha256-36tsFJx1Q5vVGfdkHflOfd6r2rTqSmQzN+O1JBtJ1iI=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.35.67"
      "sha256-NqSht3gndwAQg1UczYRElvcbQhIv5MP5X8Cp1RKnMX8=";
}
