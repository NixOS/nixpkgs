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
    buildMypyBoto3Package "accessanalyzer" "1.35.0"
      "sha256-xqzlZtspREjzFnslOFdBOwgRuX7+/QhFY2pnvWdvZbg=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.35.0"
      "sha256-NnLjEDyv4dYH/dKeCtka8P9K2V66844WLwynk1CqIbA=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.35.0"
      "sha256-kdakfB1uRg5K+FZyeNSQxvBYj0+ztJrDTq4Dkh6dqAA=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.35.0"
      "sha256-YU4Djb4Z9//5WYvkSgv9vlv4oG8Da6dP/Oktpuff4q0=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.35.0"
      "sha256-Pm/KyqcUUAQBZjQKaVhuL/9c+qfkgfeD51esgE+EgQw=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.35.19"
      "sha256-EP342ZP67DkGOrA2hLiv0iE1mL6SpaUOY8BHCdhaqRE=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.35.0"
      "sha256-rCVMZIStwQKsE7e2NAk9mOYkZExCiNLMfnrCUa2RBUE=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.35.0"
      "sha256-/muCi4o6A3bmAvc4w5lSla9ZtE3rMkJoL3LlEjzKoms=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.35.25"
      "sha256-6jtBmuho1j8GE+6sxqdYYf1XtonWoUu3Vi7tMDkTpa4=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.35.0"
      "sha256-UuryQVRq+v2w7uGXJrr5EDvCiFF6eAG8jvW3poFv4x8=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.35.0"
      "sha256-yZy38db9vBO64Bw01X2iDEQFb4dBGik+3qLntaG4538=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.35.8"
      "sha256-YLoxt3nGjbgDjjyfyRX/qQamX5LpuXhCU6i9msGl/aI=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.35.0"
      "sha256-4rtLxGyFJwEDtI8ec8mZXS2adTsmwiAOF2+ExtQgkxE=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.35.0"
      "sha256-jwjD2mkz6YpUEOwEHMNiIzBNoVwYUUONQjKZemGFEl8=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.35.0"
      "sha256-tNCfrUzsRHhpfIY+D2Y+OscMnYw7lGeYhFvs+wHq9zk=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.35.0"
      "sha256-aPoEEfQvhPoT0CPcfoyhzdXl2jSKeIoD3gBEw1f1XWU=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.35.0"
      "sha256-JsQYZqlzCM64Uxk3btQZm8dX/oSHsy1l29dUG7n025s=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.35.0"
      "sha256-PQcqaUxzDx91mwL55prFG2EFdQQw278ugQUAVhgzLX8=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.35.0"
      "sha256-1ReFVDH1azvSYlTskq9WBsfjmW9tOvYvDOoH9Vq7X3U=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.35.0"
      "sha256-SromjIAtmmIEf90outLLcA/LQjmvj/QoIwpxFcXJfls=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.35.0"
      "sha256-NDA1+HZ+Srs5XyNTnHxOjsUPAPRPXgeum0Q6h3Ca7zo=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.35.0"
      "sha256-KuDlcfOuF3krMocvgR2LaP2+xKeYl2CMPKRewN8inj4=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.35.12"
      "sha256-mHIUStFvFUTvHYWdZUNcIIOI//vNACI0veXXNLAAOVY=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.35.0"
      "sha256-l5hKmbwel2Z5BvQbuKXRsfusKU28laF5mVDDPW+Ij0g=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.35.25"
      "sha256-XcD23pDz3oaNwME+iqmDQr9Lbz8z7NVduFEiTnxV55c=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.35.0"
      "sha256-nr00I/1oqR16ZIw3+iA2BrS0C0Wr7UlJ48VnuOFIcb0=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.35.4"
      "sha256-XRAj8UYVmjQ0GjAevPGs1/g2XRsoCElCNaj1kPrWyCo=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.35.0"
      "sha256-Xvclx5MTWaT4fh1P5+xud3CuWYM+Y0F0j69iz2ITuts=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.35.10"
      "sha256-wgEgdD94/Ynb/Zd5rKbtUX196618kRzu1osq2Zi0h6M=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.35.0"
      "sha256-8IRkY4sMGkj2ZxZBM4n/7clzQHwuon8wmXIOAGa4nEI=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.35.0"
      "sha256-LVwSfDll7H0xxvF6b2wlqr/gQ5nR4oqtev4ZT4hgJX0=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.35.0"
      "sha256-PlOL9fmTgWo8jF17Um+aDDNShQWpCxkkp5dFBHl/494=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.35.0"
      "sha256-6iUVQMXsam6ALxL+g7o/l3KIQLjnBlp3qgkuarPW/SU=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.35.26"
      "sha256-WJ0Vjppi+dDYwqL3Xu+VWc+KIbhc9CHzAU3C5x5eTHA=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.35.22"
      "sha256-1MB5ldBGqYDZMkYaEJ0nK+jM5q/TkcN3wllT1X8YnQc=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.35.0"
      "sha256-nMDg2tBX6gakw4nHwxmkMshM26hf+x1knK1GRLY/BeE=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.35.0"
      "sha256-BAHAhOT7WanSavOe4iNVeJ0I4+QW2Ymn6C915sTQbwU=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.35.0"
      "sha256-eXgK8DJugHC1r9qPVK5ajdr/ppDnfxBHxB0tSld0icw=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.35.0"
      "sha256-mw4aJjeN00ES6lSvjDHBCRowQmPqRzvdJoSk11gJop0=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.35.0"
      "sha256-FytBZE72zKuoagYWnfv77mS7Wx6WcE427Spd/2h78kc=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.35.16"
      "sha256-O7mrqn+S0rDcOnhxXI10mB/NHzI+f23HqNXoO5gxiPc=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.35.0"
      "sha256-+RAqaRHKax8sUaOoIaaT+HvW/EGir2daS+aqDWNoDwA=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.35.0"
      "sha256-Sh+w+fi1myX1QUR0JnQeE4/fh2TSVvXIp5tVzxigu5I=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.35.0"
      "sha256-T7rLgdtj8PUAZ6WRRkFYH/I6bqq+NA29kddxeI72UVU=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.35.0"
      "sha256-pU73zcHpJjazGSsHDUcWQezvdQfrP8mV4CROICuQOq8=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.35.0"
      "sha256-DQN9nWvbQ5qE4jkbqYek4D/O360OiB2xzw94YdJ1kHw=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.35.0"
      "sha256-ewZmBuNAs3YS2tG5WDbNBRr1y1BmmOTxvXrSASNhAp4=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.35.0"
      "sha256-/zmoWmzYLCtRC6ZnnltNeXL3MtXzHyDgoP9LKsR1dAo=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.35.0"
      "sha256-twEjxoeN4rSCJ3uN4Jcyhd2cowPnMQ+O7zoWooE/Nxs=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.35.0"
      "sha256-BfQ8gM+yWcqOpmM+G8DQzJCJYwQk2zbf6v25ZkGH0y8=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.35.0"
      "sha256-8QLyd1uCh26njr6VnNBFROHWFXMSvpO7WRzV8DFZ01U=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.35.27"
      "sha256-EZzFE8myIt72X3Mxr+ZZ4lx8O+nTARvm93OhT4ekYpE=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.35.0"
      "sha256-YGz59Mf6cNqNAJmdI0YQF9dzzUY6Mwi7fgzsDwMWv3w=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.35.0"
      "sha256-DXAn45lDLDoA5T7yDRRYwz7HI0l2SYxB6TZAsXZS2oY=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.35.0"
      "sha256-NXttDVG1iAGoYefRXROKaXiQUnRXxiOcOUad7ZuA2xE=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.35.21"
      "sha256-sCIMOBe3VppVALMDc4BV3rK+RYlCbxK80YUKPnckvT8=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.35.0"
      "sha256-VaY7Xe06Mih4/nj03+e2rbSuRKZhuNlcWv9B5lqVM80=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.35.0"
      "sha256-uYcDPjNaXSQrGjkvkARXZCd0zinppzlxzwqXSDln8UM=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.35.0"
      "sha256-1IJOc/HNHlKr8Fu3mz0eSvjl0O4T15qvfQtBI7B8yIQ=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.35.0"
      "sha256-CtUYNrOocrt2lKCNb0K2/GitWFYhhspM4upo2Q6qbuU=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.35.0"
      "sha256-6YRFmSjoVc+wEoYAElh0xeJ+V+TK2WCQuxW0i2yh7s0=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.35.0"
      "sha256-UJmPVW20ofQmmer9/IYwaFIU2+xhXcT+0s2aUxFDGZY=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.35.13"
      "sha256-tLQEsxoPyDA5cFlsm3HAOQPCyZApCQOBJMxVPDH6Q+w=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.35.0"
      "sha256-FgwTiMwMb0ujBqMcl1kCQVEk0HeCzq3Zcj5dXu9BCYk=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.35.0"
      "sha256-7IzW60xRrkzLorC3QJMX+iP6DN46sdaYKizNFTNTL98=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.35.16"
      "sha256-UVEJn/VNbYEIRPHV9CuDI0Hos5POiMQThiN4OlncQIE=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.35.18"
      "sha256-StmODomtTdvtjYL54eNQBWWuVLozMB+sowpZKeGsYX0=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.35.0"
      "sha256-eKmSJqNDB4rLeaiwors2mvDteM5qNQGsGz3Xq8VqUzU=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.35.0"
      "sha256-x0D+Dar+VWHY59zIKkp8+gSL5I8gUSgct9ANplZ5aSE=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.35.0"
      "sha256-goeKEyNrj2ofR5v0nEpDZ1CLNpR0qvN13u8KS1sImZQ=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.35.0"
      "sha256-pP0c6lk9l3seKkYBW9AjoaypkRWw4YwDgJjIpkwkLMA=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.35.0"
      "sha256-1pS2EkJapoNVi5lUEftaxbdoN4fd7XSFjWyLXH1noL0=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.35.13"
      "sha256-sL2WWzsUFA6dbKR3XUEoy+CbWT6TWVQCxfdQ8mZTmbo=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.35.0"
      "sha256-S47wzXzOyTs27UzjtqtYJg38QGvBpnJ7boNlrueiZoQ=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.35.0"
      "sha256-7nPkRP30c2KVarTw4OhebqHeWQ3wTm10PPkxoP3OvbE=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.35.0"
      "sha256-lq4OWLz7+cycAuSr5dAoQ8aCbggAdLRv/dc7aUa/N7Y=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.35.0"
      "sha256-rYvtpy8Uac5YO4x/WSvUHz0aY8vYVf30gW1aLyYDbRM=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.35.0"
      "sha256-Hc9S/t+sTaMHIk93/pIWowMm0qXyyKf2Jth0j/JdtyA=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.35.0"
      "sha256-YEm3nBfWCSzwPZ3Yvm4Nf3cMxaTccvHdBrs84g7KE4g=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.35.0"
      "sha256-j+L/GV/1l1OGQk1T6X4ieErbTkfAhHUl+zSTiSoo/QE=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.35.0"
      "sha256-zzd0tw46A9NwxUJ+7tz3Xlb4RbVTY3v7szDG4/189Ng=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.35.0"
      "sha256-DZ8sYkjFA0yFfRKNQbEW2YA3Dl04FbG6Hu8myRuFlUs=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.35.0"
      "sha256-JlarWblBOzB64JV7866QjxIWqQH17qH4Lcig2g7WsAw=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.35.0"
      "sha256-lUzOmIoPNgEbJC54tre1m5ddhca05GyTSPOG4uIfumk=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.35.0"
      "sha256-kAOvmRLOPBKhHiipN17YTgKSkZU4fjdJtay16uV/10Y=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.35.0"
      "sha256-pLurujlWUyHNeHqGDdLNPOZ91VyzVsnIdDPSgGEWhOo=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.35.8"
      "sha256-NuCFTZ3+3NSlXtaG3hJTP58CBevyt5+qjIK8BY/VMOA=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.35.0"
      "sha256-KOvVP0ttOXBxmDF05GPRNvr2fKUc6+qJz3Pw53oAI+o=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.35.0"
      "sha256-HCSark4bQG673j5KZ1ZULwNiOBk/cichkGwuH1XNAPk=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.35.0"
      "sha256-kM9eR8OQ2la4tad+Q2PvO0auuEQNj0My5q4l8//9i+I=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.35.0"
      "sha256-yJ3ApQy6xeEdxNcRQG5mekfK1aP7FPdR79TfbRZkESo=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.35.0"
      "sha256-mTwE5mn8GTCMuidyk8cYnZEk3PkrnP2ykVZgn2geMTo=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.35.0"
      "sha256-gRSlQ63BPat6gxy+jZP/vtZIn6a4fXN0tx6oPvvgROo=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.35.0"
      "sha256-bmhGGMR9x0QKFl2p0p4xhxtE+A5PZQ/HO1FdLuAgLtI=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.35.0"
      "sha256-Fzdqwy9NA+R2ZYNuXcxTv5RlY9X1d609CZHbSQUp3Is=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.35.22"
      "sha256-OgK+ZM7wn7Elp6xzb1YnZtYP+eARgsP+BIYkQb+E4YE=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.35.24"
      "sha256-Vb+Jeh0ONUV57bBQAfS8T0crlFK63Z2ySHbDG98/cqE=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.35.0"
      "sha256-oiyT6g9Rnfv1LLHv5NgIUiXLS5Q3jsz9f0EswUUnrKs=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.35.0"
      "sha256-wBJ7PnAlsi88AZIRPoNgbzOhPwUAJBegtwk+tw1lOwU=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.35.27"
      "sha256-fop723a6ylbitijRkYLBWw0ijtYyi/oNP53ZNZZYxpI=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.35.0"
      "sha256-0Xe77fz+lA+nuUGK+PjU0EgWeQ7AJ9Smsb/4yK1tow0=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.35.21"
      "sha256-1+jCQIbOOyWeSsKicfw07U7/3pnHiZrH1kwto8/wrNc=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.35.0"
      "sha256-KXtN44KAIDXjMgv3ICG8rXYfEjcZ85pQ+qdvN2Yiq3g=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.35.21"
      "sha256-DSmCf9/TXUfoEYppEZOxAJOxuOCZK5p6GRIKWIa3aPQ=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.35.0"
      "sha256-6o825Pz7Vbg/xuFXR7mTLv3zWcLoRIqbFqjRcQtZOJ8=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.35.0"
      "sha256-w+uJ5Jqfbnj3ykj59C8sbhitp5MyTIE+PnZXrlIkOag=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.35.0"
      "sha256-GpOOU/ritDu+hDZL8adN5fLYhYt0bgBTqCv2mDjt1T0=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.35.0"
      "sha256-m80E+gaUJNpmrY9k4TuKaMbaAm+fCDqUbgH5IVgrArw=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.35.0"
      "sha256-mQMBfRyxFW0Mj/VX74luXxxfVTqSgMswet1fZe5qiyE=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.35.0"
      "sha256-5fyZdBW/KdryVUv9NiSUa8TGEgh4U8eLXWv/Z0DhIew=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.35.0"
      "sha256-fw/vfzKXXQSG7xj9FolkJgzciHBz4ELlFh2MlEJ6wQI=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.35.18"
      "sha256-BlHZi/WM1rKK0QWbAYfHmdpZmgm8ZpWZPZQ4gz0k4oY=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.35.18"
      "sha256-yXm2k6pDyJ1N93q6ltz6jvQy17AKpKsKhVFMpS1oGaI=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.35.4"
      "sha256-ARmcy8oINHgph9PqNtQYyBVEVshBuSHDeju2ynNSqQ8=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.35.25"
      "sha256-9aQOr3oGVejk34AInlyoS9//4DBIR0JBbHGumvanOtw=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.35.3"
      "sha256-NpMzNHyIMc850GHCLi3ENku96S8QvR/SAShsLqhwrks=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.35.0"
      "sha256-ad5PQgRxRqEQ4QOjM0wPGe/4JXPNqlB5exRHacx7YKw=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.35.0"
      "sha256-IXJGXd/J+EwN1FcHofPq9AatYysD6FRrny39MzqF6yY=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.35.0"
      "sha256-C7hTVrCUdBpYj0y5cLGKnruJcgaHFMkeY6R0fZ/Zp78=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.35.12"
      "sha256-zO4rFI2pzAFhHHyRPYeeV0eC4daRJ57GeAnAqrOyQAQ=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.35.0"
      "sha256-KQqb3NdsN8SloK7kIbJoy5I3zhO5CUr9rB8ZqtVLaDc=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.35.0"
      "sha256-7ibqWrvc1mwCDzsm/tqha/2Y2EbfxTpsf7omIZg/EbM=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.35.12"
      "sha256-rm0PB0oie7q+8pl+efohmHe8StLZVvSWYgLIajxd3Fo=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.35.0"
      "sha256-Y+FKtBDxQ2SyN8uHLkt7KKylo8uOa6mCHUwf98TsBRg=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.35.0"
      "sha256-s+4P39vLxQiAoVpxPKLJd4BgP9/OOFUrnt61EnMXUMs=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.35.0"
      "sha256-ityNtprzMtWbAsRARL+c7q1czj+E1Pxv+6bJdci6Fcg=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.35.0"
      "sha256-dUbtx84rCJ5zRHxmdpGFAychNH/F98eviwdwqmslPLk=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.35.27"
      "sha256-rPVWNk0+Xt9kMAl8xD0xM/EIbiYPSUL8Yc8b+2RcD4o=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.35.13"
      "sha256-Xd0jrg/w4CPn5mDgHTaahyRAu5RZxdMcpci0cx7/1sQ=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.35.0"
      "sha256-WpSdaAf/s2jPoGG4cLjeNKZz6kUSApTMVq4nnB1nkfI=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.35.0"
      "sha256-RJEZBr3yU/lGEainrpidLsdYBvVOPMq3cIaIpsTAziQ=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.35.25"
      "sha256-hWpxnfHPaCUlxFg/3vNhluQnc2IHYoNVq9owH3D2eME=";

  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.35.0"
      "sha256-AxH6/D5K4m2nmZor6T6bb7/PbimJSI+0DxyLOXUexnI=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.35.0"
      "sha256-XtMbgVoGmFTTFJTSQT0NRR7shxW81tmmn6JMa98k+kM=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.35.0"
      "sha256-dUtwgf8DDz3ShH5aHW8WdII8VOSDDK+g1q4ObppA2W4=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.35.0"
      "sha256-U0sYInE/1XsjwQCxmcYLVvmEQf4R6drtdSqTr0b+3OM=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.35.22"
      "sha256-+Ro4QM8DwrDlbroFb6YV6fZGYPieHB0B5+EgdNrnIzQ=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.35.0"
      "sha256-k0c7P8ozVzHSyMAGLg5arVjr+bABfZFwFU4EBQZufUA=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.35.0"
      "sha256-Df0AUKZh6S4OdqGBUtEC4cnic9E06Frj0McQH+yQwFc=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.35.0"
      "sha256-s3mgHDyhejZ8t6RgkF+c4at4MKmruMilbyil/xCHZX8=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.35.0"
      "sha256-wHm7wHBhEX3c29MwZtbZPXH1su5MsAzLmj5h8V3/3V0=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.35.0"
      "sha256-yL54l1/+3Lz4C0Um47rsybbYujc1nde2jirX/DUeSIY=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.35.0"
      "sha256-RtMsMIw5YqPiO8GNKa4VPPb+oaA/IdQgsZVNK9kpSuc=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.35.0"
      "sha256-4QXRWahJ0y9Svi/WRIiRFfo36tkKM25bXCTMrZjE41g=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.35.4"
      "sha256-NslpiIBwxTvcEe/Lh8wM2PJE31JNmu4qyCZMbB+9noE=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.35.8"
      "sha256-BWNccaLrGmm5liiAOHCeFqSlkDk8wnj+/ipExaVZVis=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.35.20"
      "sha256-3D1VjhsSVOedLhn7W6Huch4aowjlJgCuotUyln71n6k=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.35.0"
      "sha256-6Dy72Ui8OI7ROdKCBEKvHTGco33OcI30QpXErPz7MPg=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.35.0"
      "sha256-pHVZNE6mAr/IJrM/jY8fiEt1o8hQOJ1aw+oKuKijpyU=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.0"
      "sha256-I6bQTR11cWwa9ifrBsU7biYN8T7AyNDg3DvHQ0tyzFI=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.0"
      "sha256-eVH+EYKSz5rZcetDp378EyswOgPqhmOcIuApwiOlOZw=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.35.0"
      "sha256-jVb/qDhi0onfEMXDnJHodqKrEgXqPrUTseiGIUwCPWk=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.35.0"
      "sha256-mo5rWGiyoaWRsaCZsGVmnHalVpV4WlcM+SKEXm0y6eY=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.35.0"
      "sha256-NApPJ95ciwJF400DGuTHm/xeeorYcyc5iXejPwJ9nUY=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.35.0"
      "sha256-haDAVJsgAUYlFIC2Gv5w6qDUfMtbH2eWmYW3wEURH/E=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.35.0"
      "sha256-Hse02blZttIxqJovJ3h6yCEi+jN3e+pfznIXjBAid1k=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.35.0"
      "sha256-VQCFJX2wZYKWey8yxEBoAK29uDxb/xn5+EuZH739DV8=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.35.0"
      "sha256-A1sYvlnpbfKZyxZvFCzBfD/Jbzd1PwlQwgj+fvcybGU=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.35.6"
      "sha256-WICduOodvGT0EP7Txjbe49f0+ZhtVmzkIg6XJV4qHJU=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.35.0"
      "sha256-no67GUF7Z4TcqbWUYG18bHRP+FEccN9P/drOP5HQx/g=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.35.0"
      "sha256-6w4Q6vynF47uBeTNBqus4hM9Fy5Bs3C0Qh/Ig3sPBhw=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.35.0"
      "sha256-e4a8Na1spmmaUVAiAWPvn7DqzYHzEL4EatCewrRxJKE=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.35.19"
      "sha256-CXQnPKSn8oMyj2V2+iTjcqPEGykM2mOrRDVTkYEX/Jo=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.35.15"
      "sha256-pO8W60U+c56/1F7LECM4AcOMIW7sHifSd9Ov+HJ4TpQ=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.35.19"
      "sha256-Eb2polqqaboA93F86ZpJ9IzZRY5FRRceq+wLp/V2/2U=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.35.15"
      "sha256-mY1AapHaDKxJTZyP44wgZhRfJEGJubYMsV+PhKgFxIM=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.35.0"
      "sha256-xHARaL3zzxY6jy5VyQIrZLXqwvfprktif4pcSk+7xzY=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.35.0"
      "sha256-fnpRggcnA4mhk1vU7I0x+nn6wvx9PQ5Gi/WckSgfZ7c=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.35.0"
      "sha256-lBZ9MJQsuM0vRyrDcelDXTIhP9sex6CjnRjYY3qjIdE=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.35.0"
      "sha256-ZtixXownfAnqUfNY53sVGbDZTQ2Q+Hhzgs1Txuyn3gM=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.35.26"
      "sha256-hl8ml/Yt/H0EBSQ2qSW98NOakxfN6MaYGmrEbmWcHH8=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.35.0"
      "sha256-NJtU+ccNQoz85Q9TEs2TlmLtbMGo1U4Poan1d3Vpcxk=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.35.0"
      "sha256-bQ0w9UuocZjfxjdcwms1vaNnCoSM2Xis8bBNzuROiXU=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.35.0"
      "sha256-5dPgAwcPymYdrKT+YhyRkFOhfDj71xfA/P50KdurMXI=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.35.0"
      "sha256-8DtIRagCl2UAfHGZSxX8BuHdrWHVSHSJ+Wftr3mA3x4=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.35.0"
      "sha256-aKdkj9FTE3yDnyWySWx1xXAzzPypaGZ2IYg+6AwHHKQ=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.35.13"
      "sha256-UoRFrbwA6QdFsO2z7R8If5/0Jf6ebMTJ91jqEh/Ys38=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.35.0"
      "sha256-pQB1whgSUK17rS16iaiucSiKMKJPP/AocWH+YlbyX6o=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.35.0"
      "sha256-oGpeVJ4uuNUAIsZwc2k0QKLtzLSHC+ULM1f3Pcm+ZPk=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.35.0"
      "sha256-d6dz+lqK8RJ4kwDvK8WYf5U3N9oic5s+4KJgW08/3oU=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.35.23"
      "sha256-I70ebuqU7cWYu+rAWqaUbNNiXdq9JZL/dm8++OiJxao=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.35.0"
      "sha256-VkE2UkY88ZksHpwTVGgjA80mTzO50CI1QPdh3Ug/RGc=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.35.0"
      "sha256-oZo6Drdgh8LaT1aheCZTmOLfa8aacXbwtkU33pqX2Hw=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.35.17"
      "sha256-Z7WxCRl7U+nEEeCHgQavY35pvYrS7vDOpf9KPzbMDSs=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.35.0"
      "sha256-DXz53R1jyNNfcHzADr8U/jnhBrhlhrNA+C6Y8CD5dcU=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.35.0"
      "sha256-NVBQJN2YIg/2FNG9oViLw7pWhcECaYCZdOU9tWM9z7Q=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.35.0"
      "sha256-xrNvzGZkTDmWtEJwfoZmoe0vqHWmltV9sV3OxLy5JeM=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.35.0"
      "sha256-1xu8CxA0xJeHPjAkAr6+csVax9Kzuzc0DdZkTu7iVWI=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.35.0"
      "sha256-+5GMpqC4EY+1atRrP0D+KweA7mvHSwZ9kKvrVDDP+HU=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.35.0"
      "sha256-6Vs5eRibHCZvDDIcIEThPa6T1OmfJXjLg4GAZlworsM=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.35.12"
      "sha256-H+B1dxaGAAwAqWU5/WKKYz1HT9wKmvjVEg57kGvTDh0=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.35.0"
      "sha256-BLE7wcDwJIbuDHbK6x5ala2fzMy+Di/1pSBfUoYnLy4=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.35.0"
      "sha256-q1jBCSiyznyNPEa7ZQwsCQRQ1J8Wvj/RHugaT6ZDBeY=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.35.0"
      "sha256-0Tz/X8RIuLvbDRXmZ+g0aEOcO7Qyg7ZKDLW1bN4yfJA=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.35.0"
      "sha256-rn9xCU8qtkR/zRzi5MM9dNInJOa30VrYRj2hBLN9Zao=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.35.0"
      "sha256-TNj5R4DxrKdlOa5u7O9gNwkzMkLPP1mcxYyu3bbONgY=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.35.0"
      "sha256-0L8kIa+KYf4hQW7ErpCMSEcgkHmqS95vt0YaCFLk1BU=";

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
    buildMypyBoto3Package "mediaconnect" "1.35.11"
      "sha256-v+a4wc62OnHXJv5BHy/oq88FRn3piimmenmAPAOZXOA=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.35.23"
      "sha256-TvkVif/foJUzw1tPg8l2Y81neHUfxeZ9aDKtaIYKyRg=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.35.23"
      "sha256-emjiDJ1sZylGgclL3E90nYBwqJgJq20fQx2Ug4e9UbQ=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.35.0"
      "sha256-a3ToXuhOWn4H6yEf77XWFRpG1QOFWn3tuBzj5MV3HZM=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.35.0"
      "sha256-ur1A0iPMGgfI0XNSOiXX4VF5nR6XJcnpk0KM62Ujp/0=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.35.0"
      "sha256-b8TqRWLKSkN74xBzyCeABdd69s0ET2QTSNsTZaJXPfc=";

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
    buildMypyBoto3Package "memorydb" "1.35.0"
      "sha256-hulSiv/A/GXV9rCjjSSIGKQSZqeBkKUKZuuKGwl8/aU=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.35.0"
      "sha256-qFXZE2y5MSpOZMSKhFEeriXHgbboQigOufmTqbArmns=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.35.0"
      "sha256-mGKHl9Ld7DNwma0Nl2lTwb3cN2N1SqnZlYZX0bxnS1w=";

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
    buildMypyBoto3Package "mwaa" "1.35.0"
      "sha256-J1tV2BTUW2Bu8ll+Yn0cJpUpMCCCkfqUEAnis/OJxrA=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.35.24"
      "sha256-2hgamfnf5SPWo8R15FWJHO37IC0y2oLDTHsb/oPjArE=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.35.0"
      "sha256-Epx+p5M+3x0plFaXdc8Rsz+p18ZnxbNlr4IhH5STvZM=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.35.0"
      "sha256-41zAgq4F07hIl7I6S+M7ngxdFOKjmUB3BFhncLel7ZI=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.35.0"
      "sha256-z1YOK7DoyTEWnaWJ8x8VKZNETw/7jPXBjmN4ZX7m5E0=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.35.0"
      "sha256-jHEgFpoHJmep4Lv+ge3DSDthO6d9zt23lWBp0MztcHQ=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.35.7"
      "sha256-CwD0stU2217XD+SXTp+WRyf/qH3EOA5PuBSdTWcXOGU=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.35.0"
      "sha256-AQLU4or4flXLxTrZJy0XHIn9MFRTmgHjUWjLzuP2pXA=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.35.2"
      "sha256-df8udPQOjXo5GEo6Gk5G6oKx7pBW4c0A82wkC1PA0BI=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.35.0"
      "sha256-SkQUH/vYdyq+YvCfqZlC4hwxirn7JvPwxBVg/Z17M0A=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.35.0"
      "sha256-qyUZN9Gz8Q6TBDg1LW+M58TLwDlmqJ9aCr4021LbSL0=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.35.20"
      "sha256-SqZDiV8VrLmcdW+cO7LjCFipeJtPlL04uXx58UDgsg0=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.35.0"
      "sha256-PdOH3KaQn9d455qCR565qFlyCb8t7R8x8wXBebHgtt8=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.35.0"
      "sha256-CFULIBMCKb4mUQ7ogh5hvfewDMpsP1jnQEJmtuArCck=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.35.0"
      "sha256-HFjrSRkc3cEqImMkqC4V/lfk/ArD9/2swrK7xo9Hut4=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.35.0"
      "sha256-b9gTTuQxsXE4CjZgRgbZn4xGSC7N/4v3eF4fF9fFSow=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.35.0"
      "sha256-tHHuRkz2nA550ldsMbiUS7XJGMHgx3rRt5scFV7tFNM=";

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
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.35.26"
      "sha256-NLr2dUrIW3bwuYg9XMMaBE97aWZqQr3onXBcME3EEbE=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.35.16"
      "sha256-Mur45GAzHsGamKaooUdGwuydMbfaQCSTVrRwwENbmFs=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.35.7"
      "sha256-aIKpT15gBmM2gkkSbmzs5pVvAIfessdzlQTspmvK+LQ=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.35.0"
      "sha256-imX//FkRBbNmc69jJINlSIPB0WZc0AvIRH+/c3PRSn8=";

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
    buildMypyBoto3Package "quicksight" "1.35.23"
      "sha256-ljk8uB17CDpGT9TIAncsrZBGbI9UrPAPU3HQ9Cz2zYE=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.35.0"
      "sha256-kwKCaPtSl9xFVw0cTDbveXOFs5r7YzowGfceDSo+qnc=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.35.0"
      "sha256-85yUjKQ8oiECUYHhmmYrDssyFSQb6itfIRY2iuwCZdo=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.35.25"
      "sha256-I4lTEWslkWlrayRnTG9wZcSdihSEDd51F37a/zdaMY8=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.35.0"
      "sha256-yLKWipyD8l1Zyh840Ixp70maQBz/aDcnJEznpGaXt+E=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.35.0"
      "sha256-8YX4mAvSCQgacJy+BLxuW6+gojDz0oT3wMtJG5P/WP0=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.35.10"
      "sha256-LP5RjvMCfCsFD6z/0mIZJEWN3y+z35aZzboz6KaFlZQ=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.35.0"
      "sha256-uHY9c+p407QBVS18N0lEshdB1mXV+LONhTXSIr+NiV4=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.35.0"
      "sha256-mG3TeywuB5+87Z3nhqjFwf0y2WO49oETPMz+oL0LbOA=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.35.0"
      "sha256-MKlBdSJGl7WCnD66fx5nCPhGAtLtLjoahe08KHTT+KM=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.35.25"
      "sha256-49Ysavsq6tDUQAcJiP4GQkt5zgBz36qufByA88bltco=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.35.0"
      "sha256-5l6yFERWSvAgeguBrQmx7fzRmSFW95As0NIqo91VTmw=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.35.0"
      "sha256-3DVLn61w42L8qwyQB1WbOPjOZXqXalLZ9rITcmcDkQI=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.35.0"
      "sha256-Yl7v7zQHeixpG244Qld1vceR8ZazGjcUc26LUuane3I=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.35.0"
      "sha256-Ss85x4OJ+RtOmP7LzIIMcikxjMvMyi3VUT9WLvxODSM=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.35.4"
      "sha256-gPor5Roaoo3i0zJa4xXIIb1SOar80KQvVi5h003vGZM=";

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
    buildMypyBoto3Package "route53domains" "1.35.0"
      "sha256-pM5+b6he5Gp9DuD2Uz/x+SYmVzxhZIh/gJ626S9I19g=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.35.0"
      "sha256-F0ixOVQ8zmCrspV3+a5QmuJdvc5NOV8WiWdepiIeW9E=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.35.0"
      "sha256-RwPNNFntNChLqbr86wd1bwp6OqWvs3oj3V+4X71J3Hw=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.35.22"
      "sha256-n2ThGW/+zCxqt77pXoSGkrX0ZKHfFCETYepru8IDg4c=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.35.12"
      "sha256-GpZ3lr2WenLA+FNOBnot9X7DQKtmxWxvP85bTM5l1+g=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.35.0"
      "sha256-P2Yg3qvcdAcjY+uwPg2DpTgT6ZXb1XYCOeu4bVfgFKI=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.35.26"
      "sha256-mVFsFO7dOxHCkNxbxYUED0OjAabQ1ZuO/3MQiuy/ynQ=";

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
    buildMypyBoto3Package "securityhub" "1.35.16"
      "sha256-qDb5EGz/of/glrIKMz5xkPbatIhjRjs9L4tzW0ckJKw=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.35.0"
      "sha256-cI6Ei0p1LtQ+QuM4URYu+k2kJiUUjyEs8rbeX5c7Vvk=";

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
    buildMypyBoto3Package "servicediscovery" "1.35.0"
      "sha256-avjVAYAQf5ad7CYweewSsbg0JmLnK3KhY2RabXdiqAY=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.35.3"
      "sha256-+TyI+ffXN0M9HVWA3iQfg3T/xF49wslYFx9MTxHCfYw=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.35.0"
      "sha256-bKrU7HufafU0Elt05TLZrPycs3kxEHdJcKp6iwWB7ek=";

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
    buildMypyBoto3Package "sns" "1.35.0"
      "sha256-+wg1gb5M2pliaC/dvBBtlWc6MgWNrIwYyJTAe9SU4r0=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.35.0"
      "sha256-YXUvHCvy76OBX2TUPCW0o529vZ5HKuSKoY18bSp6brg=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.35.21"
      "sha256-XtVcdQn63aYVVxj+WXKbPasPi3b/HgN6h6v/ndJHX0k=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.35.0"
      "sha256-0X0GgJ9dQr20jgQXNg9f4ulETPVHEQYaAs7+KxxIo/g=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.35.0"
      "sha256-sMJnd2csYnc0MxS36LdvHuvmYax+zEKWLiSRMNMzV8o=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.35.1"
      "sha256-OG2416B70WCHMhuWykf1LZWufgn0pB4EsLhydVYH/pY=";

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
    buildMypyBoto3Package "stepfunctions" "1.35.9"
      "sha256-wIirZ3Ueg3xdtAWT1su3BQXI5W4OBPsyoCQeebsigSs=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.35.18"
      "sha256-RiAqxt45cMOkbGjWVWufiqZcCKQm++RE3FOdZ5BFkuE=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.35.0"
      "sha256-YZWAwLz01/eYCMgyiniUoO6sVvlFQYM8WjKcvHCPdng=";

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
    buildMypyBoto3Package "synthetics" "1.35.18"
      "sha256-p/jKkj4a1vUkgfmUAkKY6nbDKKaBNAJeuFOea7Uvq7M=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.35.0"
      "sha256-i0NmNRPwEypr4m0vNtJDXHEAbCcqdxTexY3MDaltvh8=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.35.0"
      "sha256-sOjhGZ2h77NOLcoQX2AdLae9cB2VbBYSx+W8ge9oqwA=";

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
    buildMypyBoto3Package "transfer" "1.35.0"
      "sha256-at9iKdpW8fCiOOX6smp8lDg8xWT9M6RdHJr7Qtpzrbo=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.35.0"
      "sha256-j9ZU1UHzKNo1+gb+uUYiMTIwjGi9OEg0jAmKGx+mGno=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.35.0"
      "sha256-98NHM9PlT4c9jCcm8kKaEsOHHvFdhmAca/LRmW8biTo=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.35.0"
      "sha256-mxpiis9WGSEclfaHOxFJxGIAO42R2c5zc58xQo4MOn0=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.35.0"
      "sha256-hjsCIge5vyWpgeklpO+u3QGPwCbpdnZcfJErYrPPyeA=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.35.0"
      "sha256-KeoPZIXTGHoS69QR5y4y3N4AVlscQ6Cqlbg+6H3MIu4=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.35.0"
      "sha256-rqjBKxMMg/gkt9PJyFyE3g2msAiTtiMZWF4TY3/grcs=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.35.9"
      "sha256-snz65w4vU7DMSVJmhWHvQay38q17RYkmbk3986HlXT8=";

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
    buildMypyBoto3Package "workmail" "1.35.0"
      "sha256-1hjejKCAu9pNPzJ0gaz8mbyQLFkzEUB0mO7g7Da06mk=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.35.0"
      "sha256-Om/TFPBZh3xr0inpGzCpvTNij9DTPq8dV1ikX8g4YtE=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.35.24"
      "sha256-j7eEUDul3+bMWN80+gH+/gFBWqQHVQ2yN+YBx5VFZNM=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.35.23"
      "sha256-/uATkqLhOOPKwegWRQOSRGeM2tmq+VbWY3t780IvSek=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.35.0"
      "sha256-o8Om2D9ln23E2/OSrBSBApr2uUHpSF6kh4u/YOM4+Cw=";
}
