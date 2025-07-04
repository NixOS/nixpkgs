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
    buildMypyBoto3Package "accessanalyzer" "1.39.0"
      "sha256-yKGbTsGfjquFBHSdKIxQmS4ewTPpxyS68eQNStCg4Iw=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.39.0"
      "sha256-SMv9JHKPF6V0Qk1hhktJcpHz4cJkxWK13t7IRcSpWyE=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.39.0"
      "sha256-Nv8N4vcM4u17idYSC8OJf93neoFGWJPMHV3D1inEPGM=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.39.0"
      "sha256-y2IKxN2fxRGtnSH4D7fBWn+bcj1vCc/zBAZlfbNgwh8=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.39.0"
      "sha256-xBRiJIzq8HczBIFLWrgNpaRD3uGB9mxbEjlKzSlb0Z0=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.39.0"
      "sha256-L8mgcLqh3zTsy0DSPjGqxByJ4mp1U1f5RnK5XPfDcfs=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.39.0"
      "sha256-a3ofq1B1artSvlan7sufmAUb+3Uz4qHJAzQeJ0KLmbE=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.39.0"
      "sha256-dvACoIOv2R6HNSTnPgS9qNJVi5ezmPzzEPt+D9sb0b0=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.39.0"
      "sha256-O3yXNsNoApr1gJoQQMlgqguv0YhIoZLHgHwd4vQZPnc=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.39.0"
      "sha256-67cTUGgTLI2eVqh1CULgUdPEySBMjf22fGqCpW96WS8=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.39.0"
      "sha256-0H51GZWGXqEt3qbX5TFK9dxEgoabopqIgzPpJN8O7QE=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.39.0"
      "sha256-Y7mdhehqKi5vN66EUDEN92FDirPEhQ1JWKFmenoOBtc=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.39.0"
      "sha256-DTlUEu+Vjs+MyvhrSvBBzPgAhD5Biycd5wFXGtWlfAk=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.39.0"
      "sha256-JQmcfLFNiO5mIOVuxNufLaRllfsIg1c13zr/p/udTNs=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.39.0"
      "sha256-etvr1Nu5aInbxZ7VINX0GAVSxymk11yWDPWiLcB+FXU=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.39.0"
      "sha256-HPiNjI2qR+n/M4n8/chH58CJqVT1aI+H9oJss3xjVCU=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.39.0"
      "sha256-VEhds6vHkX2J3rdMlc3XRPWV5be/0jzhLERvetK9YJE=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.39.0"
      "sha256-58L/knmFXVUtbyGsfHqJScKx0mFAwmFR4cQU1FDubDM=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.39.0"
      "sha256-Pa4mbk5NiJB157ZYdCd3arSx4kVY7vOyAFcMk7Vmz24=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.39.0"
      "sha256-+qnt4lR0A9pW+doi18w/f+YzgOjMr/9C8MnNkGhnIAc=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.39.0"
      "sha256-0esdPcNQXOR/Dz7J9HjNPWjhwyRiCar/5MmkdYDBDDA=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.39.0"
      "sha256-tSV5pmGsd4t5uhdfhBFuPEtyncTHT7nUPyxSHxEtQCo=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.39.0"
      "sha256-aP+ThEugwvcyJrvLj7edCnf1oP54y0dmuqNYXaVKXiw=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.39.0"
      "sha256-RQkAtXDMDfIfMhGEFx++kZ1CF7fmASv3SoXxPE9YHhY=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.39.0"
      "sha256-0CtQqviDxHpTrANwKF/2E+fjbfCikjwffO/n1z8kqDw=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.39.0"
      "sha256-c6FiB1R4B0WN637BWzvI5OUUMNUDbx0wJoYxX0t8iCs=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.39.0"
      "sha256-UBLhfgHSEAjzGync+Dt1AU88qSJmxJVYRe3VKGbswJA=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.39.0"
      "sha256-W6zfXmW0IWG2Y91N2uv4yJphoC69Y3PFdoRhcrHGknM=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.39.0"
      "sha256-DTYCBtyqI4haPeMp/2YQw5PHggrQw4ZoO5BkN4q4Pns=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.39.0"
      "sha256-thoMZE5unC2SsMvRGiCytIuXUMy195RiKqWqaWE2FiE=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.39.0"
      "sha256-chgUvwO3pGIZweFagSOhqrwGgHMLrX9jxiynmF2/dlA=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.39.0"
      "sha256-V4OGSKH0Cs+CFJ8/pU55oLKdAOgHUN5Gf7EPdK4DcD8=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.39.0"
      "sha256-MXS/FQkRYkWXS/ZCDnQkYnIgQ9k+JV9fAl8FZ9504cs=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.39.0"
      "sha256-JH8+9lZOkcA3noyuVt0kQP5w04rlDy2W3wD6PzEauas=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.39.0"
      "sha256-V6h1ZGZUMlNQgK4cBENmU7mB/gHkFguc+1oyqOQ2tDo=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.39.0"
      "sha256-PJjadD1ou6hHkD5sKyqjKDLGYNMw8HW+m7daQpviBXA=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.39.0"
      "sha256-N0NprtGdL2M+e/GUs+xpo/RdkEF87dowU7e2dAge8aM=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.39.0"
      "sha256-+KSuq0TejNpFXIWiAMde4qrO9Wv8dXh0nU8RdBWdBec=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.39.0"
      "sha256-Lq7EwOd2ia8kMG3VLzeRGE21vOyAv6xIniSMAd5c/pE=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.39.0"
      "sha256-7TfKf+v/JLlpnjM7ZzLDTordBQtkLUwlaEIZdzoKjX4=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.39.0"
      "sha256-l5h3p1f+KuO3l3KSNtESY6mly6rEzHCyziFNWsQvD5s=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.39.0"
      "sha256-yttoC0IpPiXGEogyZLGIU4NaJaUPkqi+OFNrR6KKBrg=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.39.0"
      "sha256-/2cFcoAjidhh9AddtFnD9QT+GRSvhrZlao5Qwpel8Ak=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.39.0"
      "sha256-N7ybIIkZLJy2M0BOs/CzERluxWxxS6pCxoD6odkWeek=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.39.0"
      "sha256-s8UwYGLrnwclIvK5khr31mHk25nJFwJihNpFdZZF2Ec=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.39.0"
      "sha256-c0qUMt2dvFgmJCTabQSkliysaBDBepkz5kOBgNIlQSk=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.39.0"
      "sha256-klx1IWEBPh+8w729pvlDZn0wGao5co/n99G83qgUDts=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.39.0"
      "sha256-PVBdGMk0fOflb0WSC1KQyl3wPm1SVgZTslKMcc0HN4E=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.39.0"
      "sha256-APsIJ5mCLjVHsE23qVnE3BT/ylu2rkfnHt3tfEVs9o4=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.39.0"
      "sha256-Yic6lhbVCTlijNKTmJ1We7QMu963VMhp66HG2NGIQXk=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.39.0"
      "sha256-z52iCAE7sb0oIE2NNb8cLQL5+f/9wF6wFhz4iOMZH1s=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.39.0"
      "sha256-KJ5MyiNQSIGVuocdu70Bf5rKzuSejlwtQAICGlV/mPw=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.39.0"
      "sha256-BrY6h9vxSjr9XH5NBpcvzMxkrgKlJxgTdXiUpkV5J9k=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.39.0"
      "sha256-UJ3vy+Vf0miHueUzcgJpac/3JAMZKInywjijYx7NoGk=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.39.0"
      "sha256-qcMzN8Lep9WHi+yzt9FHsA4UWU8ilGDfRdlf3rxFGAI=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.39.0"
      "sha256-yikzOD1thdZrnvBAjJK8M2Q3ld3jfPc9miUQAYPD8dk=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.39.0"
      "sha256-iK4gcn5godd9hDRrG2P0/4dPKXbqdsomhQgqtuxSi38=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.39.0"
      "sha256-fRokHncTaPkl12Kz0dveIvknHB2xnZKUTrwqo23227k=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.39.0"
      "sha256-gwrh25FlmjPrgJzWU6OHSwtRGJvGmYASi3AOOKa3F7E=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.39.0"
      "sha256-i+fRQhuuym3hZ9f1rLYlly+jn2V+8tAn0ZOGu++8KCA=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.39.0"
      "sha256-0HWAXkm2USFL5I4GIjS4BeWLO1L90ma28sUmO9edz8o=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.39.0"
      "sha256-KNEFplNmMGR5lTjdKJC9nLumIg5A8ySVXNi8G1InXn4=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.39.0"
      "sha256-0eacO6WuTwUgxpCyQHoWR35pP9iuoMWjwyKFBGXiFgA=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.39.0"
      "sha256-0Pca9v9dgMW91yNjK7Bg/mYcUd+0q1x8juzx5TYAgUg=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.39.0"
      "sha256-jQ1Qdb45ZUJdW4VNLcO3nhkYbOVeN0syBeHq9PYAFzs=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.39.0"
      "sha256-fb84eVz3WifZv1128XkUuzSRSJbFefBsmI0LYG12yGM=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.39.0"
      "sha256-A6Xyh29htjiWbthdtJ9kwqqMFmsftNMxB1m1sPod0zU=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.39.0"
      "sha256-7PBM1xyTu1Q5zqRhRYu7R+DvMsrDsUm4dgn90qxKbbc=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.39.0"
      "sha256-RDE+kFtCY6s8jXbqRzjzzrtMnIjPSuVWYcpnEH6Z8Cw=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.39.0"
      "sha256-BNETZYYGi19ubzQn+wwgMDtsf+yDERQm1ebZwRSp7JA=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.39.0"
      "sha256-ZcXizvC4Y/WkJnyegLLdxkxvv3LD7A/XB6k7Lb7UkI4=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.39.0"
      "sha256-eZC2Lyb/xh+bQi7qskPjrrQymOXgAaT0UB20T/zUpNA=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.39.0"
      "sha256-EHjHq2j3DFJsBei2WTVztR4aUrkPOwpxq8ksqgI1KSM=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.39.0"
      "sha256-YVVOm2vuCR1dmZ2mXpy2L8oFZIX2/WJTAZTA4AQWwzI=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.39.0"
      "sha256-YfwqwExlbOei85etjjRwrKOKJ3eHZwHBXW81AzB8234=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.39.2"
      "sha256-KJ9F4modQptUT0IrdDUwN1E52Qs6MHQK7tMLCtsjAIo=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.39.0"
      "sha256-fJWzPJcbXmXNbvImqcWL8b6Z/hRDw9jme13SIuKFTXk=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.39.0"
      "sha256-2ektlJibkY51goxzITu7xveaQyaD4LSFKi3Obz0atUY=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.39.0"
      "sha256-JAQSoCm+LcpRDLY8GE2W5vYNxj9QwDgPL2n6zatdPNg=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.39.3"
      "sha256-qkRHAYFhhQmUcjOymHG+LUxoDjEx365vu7SPyBWXen0=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.39.0"
      "sha256-jBiGPwsP9OZh/wVR9UKwSrvUmHcEa7pLm0qP7Y++A20=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.39.0"
      "sha256-grzwe/8l6oHe0MeMD5yflOiUk6tWnm1czmOfh68LvlM=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.39.0"
      "sha256-H7m9wDKbGIxgCUpbwSoaWJLlTd/xPPUuhbMUf2TzmjM=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.39.0"
      "sha256-cz9q8zps9yXxusgZrYQz3Gkh+dyCtB50Ba6Q7/VhYk8=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.39.0"
      "sha256-rQrO5oQg7khyOGKWI3cve4a7VLSz5RXP9Gqvgss0vLk=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.39.0"
      "sha256-TqLW3mfUziXQVGaacwmk9Wszjs2AuEedUBB/eNEeLzE=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.39.0"
      "sha256-k0QLe6p/UuySVT5OMzWAC6D3ULv7jheiFCSYLsMZFG0=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.39.0"
      "sha256-XvsOw+bVoIdYB8OSMzE2iEl0G+e4oE43DQhVvU/OVT0=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.39.0"
      "sha256-nZ0sCq2q66BUPV0jDMzJIfdfzTUUiHFBQWDZDL4dM34=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.39.0"
      "sha256-XvPYYCG1aa2cHKr19g6sjMwE0psPhn+ziCOo5+1c9Zc=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.39.0"
      "sha256-xSlaiQN/knG0Usb5p31aaAfJwCp+G8QhzsHX6VMfk/M=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.39.0"
      "sha256-snbFbr+HOKSJblTXCCOFftIgM9F7mUzALxKDAUuA994=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.39.0"
      "sha256-mtHoZxeLCGJcCeFcaw37rgADE2FRCG8yrXmyPf2WghM=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.39.0"
      "sha256-rqU+I/5Jn8WqR7bXp53v6TGlgZE9GxYkM/VBQ6TmxsI=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.39.0"
      "sha256-g3IS+edRJ9S9fFsyVBBlnWwIJoW9Ns20UCBDuuHyePk=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.39.0"
      "sha256-ABkyx8NyvuPd8ABdsE7UDbFXUkoW/pKU0/rq9p71zq8=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.39.0"
      "sha256-w7r8e0+NWbrJp0NsfM+2/jKZG8f8iMYiZOqtBq5j+Kg=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.39.0"
      "sha256-DS3TeOU+tm3s/RwTp0EFM0ebOHvf4sM164y99+rWcIg=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.39.0"
      "sha256-uYeekAsfyETYQYWR3L8S+uzlp6EQpvYEWsqiX+60b/Y=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.39.3"
      "sha256-6qP6021SWUQIswXTFaKE/HUHyFAlBXZO+OukAF3GM5A=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.39.0"
      "sha256-VbEhzVf9uNm1DmyEvAUBEkHawITLiArgya5kwotuYbI=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.39.0"
      "sha256-fsGs0xUocXqkO2ANby3RuluJizT9HGgo6GhdeG5SMJg=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.39.0"
      "sha256-W+M98ZNbMDfxmEj9KW6A8LfCiEvB99ULc6aFo3ZQYhc=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.39.0"
      "sha256-xGvtMrln1Bl/LTmE0uq94MDrIy+V4VpH1y/42adcNMs=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.39.0"
      "sha256-JV592g8Bf+nnxgGOvMyO5IRXbixchqoSle26fDhN5qM=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.39.0"
      "sha256-PeooBL1ZdrwWThe3GMClYu6hBe0Ouf7TpYj10voAtgI=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.39.0"
      "sha256-6JdlduDkiajfqHZV+ftxnLpen6xgaxBH9RZk33KpLdk=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.39.0"
      "sha256-49/RjZheJOXyLjXE6+R4RorIUof41XbwnBdcdcGMpD8=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.39.0"
      "sha256-z2nH+mKGNbLlsZ/vsAmsb3UFnxn7aiqYVaTDyXGM50A=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.39.0"
      "sha256-h3JKp5sy5ffpgg0+WGdGap6tZXLTZvwRTiH9jwtVZQ4=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.39.0"
      "sha256-WK1TbY46qCD6V+lRv2hqEG8xtjF37xJO6K2t5gj2xLU=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.39.0"
      "sha256-Nxu4G4ww6yTBukU9TwhO7jVGL57cEFdsNadDUCDvQKI=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.39.0"
      "sha256-XMMFmyUr+ZfWDptqhhaJ8LH0NCUGdvGcxjuCUkkXhT4=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.39.0"
      "sha256-haDmIUvumUfOJcLoGMlSyi6wIuaU6UxFqNr9HrLSt9I=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.39.0"
      "sha256-H6XX9elLdxWO1qNGEIaFvGodNpQq5pBzWm1HzE0yK50=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.39.0"
      "sha256-L9PLp2dTy5d0mhFixgtPDPzxEpnE3Rj/hjyFzYxaFQ0=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.39.0"
      "sha256-79UvqAA/7ksixC6uMn51PiJiw4IRmT2WmjVylFvkbrw=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.39.0"
      "sha256-/9wyMPLM8T5ZXJ2/KB7uriJUmcyBbRgMczfIzVgSYa0=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.39.0"
      "sha256-LRaSN0AiRRPXEXt34g/1GaHRtB//8ahliLNvJzG3kr4=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.39.0"
      "sha256-KVSXcupqlVWSL4p/1g8mxVSNpYQnITMTOGIgc3l2rWE=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.39.0"
      "sha256-90dfHA5XIsXtnVEKNHxu3RtjORzKZiTEKhPCwwXsMsU=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.39.0"
      "sha256-HJqoxu/zqPSIKcBkYj2XovrmEYAbjBjjlY0NFgTcbS8=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.39.0"
      "sha256-qY9juGnpzIcczhEa4r0+HG4njqRqxiko1j7kcqOE50s=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.39.0"
      "sha256-ugvQqCDYOPldxeIuK53SGHuIgtPR2IRER2Qw/vA5/oU=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.39.0"
      "sha256-huysJ8Iu/wOKlJ/wmChRoZgWVjZ/+YhNOz9N2xMlG6c=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.39.0"
      "sha256-MFEAEkVvrvF7YRwMltQbqU7B/qXUinuDDArmFh2QJ48=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.39.0"
      "sha256-IvEuM/ERHddr3B6bWKOnz0wsCcmc+rW01Zpnx/W2fJ8=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.39.0"
      "sha256-JEPu7qr5y7dFmbt03bFwODCTwQQEewHy21sqdW9/LZk=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.39.0"
      "sha256-JAfdHmdRyy6hnI4jBDqKLwvPUxVjW+4wII6Yokg23YQ=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.39.0"
      "sha256-pKeTUtqqLKy5DX4ASRJK1LpRg7Y6KnrnKcY7twMXiHM=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.39.0"
      "sha256-4/qAcT61fAmvHX9wVwcbNvZuGWu4a0dmGhlz3HH8668=";

  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.39.0"
      "sha256-/R7AZcGOrM9csjfN2Q1bgadW7nK1KOGQM2PbDucrgl0=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.39.0"
      "sha256-P5YZ00tFGP4LlPkiPBrfDEgCeVsXb+wk0YWAjQm9Ofc=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.39.0"
      "sha256-F0Iqk3S9DlNmyV/HRcFJeHIPJRjSwivngkCCAr9bevI=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.39.0"
      "sha256-xWDtNvT6WhFrEx2VDb1GIKbb/wxu4o8JB/xUBK1tpxY=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.39.0"
      "sha256-cxS+IGjHmBTWOOp0ixN8dJrfVAY4FDr4JtplSDIkSj4=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.39.0"
      "sha256-rBUkdON5drXHUMKdUUcUyQ88zFGLjCaOSLnp9BG1klc=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.39.0"
      "sha256-hHqNvfugzuc7Ab9kz7TA85PuNGd7ealuSYDKEIGkVWQ=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.39.0"
      "sha256-bC4+xlMiLrZZk6gN6MwfXJ52/BWmatFTdDHO4kGxsV0=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.39.0"
      "sha256-On3ZXIYkKHLIF455qpB7zZLB7irjcfoSm9OXDLQv840=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.39.0"
      "sha256-/8z4nQItxryzox1LIOB/q6pk3zk0sGGRL8c6mZ2AZ0A=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.39.0"
      "sha256-mtF7lH6lTWdRE/fdnxspj5VnpY6q+yF0TJWFRP4EgvM=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.39.0"
      "sha256-/U37+NIE+QgNZoUUcIl02jpL7poCuSpz1MCMjhshMsE=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.39.0"
      "sha256-+kGGDnB5WvuZ/V2I13YQ7nJTnbPJwsKNxqgdxbzpQno=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.39.0"
      "sha256-G0/qOyxwM0SD0MOV1F1UGgKYGm54KEXrMtgRrD9dFNo=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.39.0"
      "sha256-1u7hze/rOvs2oiGzbzxzv10C0GfKpdx7Lt4K6O2Q+4A=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.39.0"
      "sha256-4T43hQTQ6nFQcYPsBGBn6wSFCf71B6A4tQfCoOG9AY4=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.39.0"
      "sha256-I5pitSzXCToQZBVpk2n2A17sNuq01Z7LO32JNFUFsiQ=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.39.0"
      "sha256-gYtKqhZnbZehCFnLfFbIJ62WX0rBBQGAovg8FnBcTbg=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.39.0"
      "sha256-rYqJJC55Eh8uQ+tQyGt1fY+BCSRyA9mdpyHTc4MmQ38=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.39.0"
      "sha256-SxLb2ILFZsbh962PMu64UeYL4M/z1WgMI+zrkqB/mM4=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.39.0"
      "sha256-EbNPL/xMUWxdETQrgeiLsQssnG7RrPB19v+ddxo2Q0w=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.39.0"
      "sha256-RDinbbqgNDp5dmUskqDprRxL7hTyze0sT/CKXmK/ORQ=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.39.0"
      "sha256-AGI60qCw6j/Vdz7NAFMYWd3QU3AM76RGAteggHCevzE=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.39.0"
      "sha256-b7aQWBekZH29M/fCM8cNkv4ojnaG6i/uktfHnALlX0c=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.39.0"
      "sha256-ILUkMtLCkiT6kp6iHt2iZJcojdNBfn7GE9QW/OFbYYA=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.39.0"
      "sha256-lYi3aVAn8lAxuhhOiLhrWehLwVyEshErW9ccrD+Rsq4=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.39.0"
      "sha256-uuYtLyzgiNttKZ8tpH8gRidBqRSvOJmIv/PgbaDGjCQ=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.39.0"
      "sha256-fX78sDx2GEHi10cPzOsJLxTwKpnRPNoYaU8r5XRFd+I=";

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
    buildMypyBoto3Package "kms" "1.39.0"
      "sha256-G36mwjFKniqdiowwRj9T947p2mGIT2Wz1bJ2TREac/M=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.39.0"
      "sha256-UMrR80IPpkYrz4iBsArrjWbt+n58KmNOIFUUlp05eNk=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.39.0"
      "sha256-ZDoMZQQn6ElClTDZtXDm1XPecnSYQZPxggM8y/ylXQw=";

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
    buildMypyBoto3Package "location" "1.39.0"
      "sha256-2/+yZjd+2VBsPDdaHx0yO8Cjhacv/7HxO9XgG+Vut+Q=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.39.0"
      "sha256-zDwUlB76vZ+bdwg9Db5rIigCQCi9JI3Dt71VC2miOCc=";

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
    buildMypyBoto3Package "mediaconvert" "1.39.0"
      "sha256-uAn1bdgNVWL7cgdX6zRnLt1FncnrndcmyLGXOQchAUU=";

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
    buildMypyBoto3Package "mediapackagev2" "1.39.3"
      "sha256-Cv+J9TXIxWQaFCFcbSx3FIccxipTgsfO9iJ9lt8YtEU=";

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
    buildMypyBoto3Package "neptunedata" "1.39.0"
      "sha256-Jrgjn7fXiMBZ87VKHcknDlexLfHmDYuN4TIyGQA4fAw=";

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
    buildMypyBoto3Package "omics" "1.39.0"
      "sha256-F3NyoF6+p+icDI14Ieb1Kv4lvL0Qlyxu4svExfcaRSU=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.39.0"
      "sha256-p5/RFmChiQPK4E5fXChIQrbqPG5mNAKK3CCpiYMzMEQ=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.39.0"
      "sha256-fEGMp3ccv+I8pymNPXJM1iK+7HJZKbKLfEwxN8eaj6c=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.39.0"
      "sha256-tDHqekgcelTHYZze0rvuHHMseiyZF7ZL9VY3LVvvA8I=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.39.0"
      "sha256-Q8Rpjv6omBDmVt+f1kSLkBaQAzVFLU4UqgsOsjnUYLE=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.39.0"
      "sha256-Ntxi/vlYmPzqrO/Q+sTaOqGB/gnaIThrEcrdcmNawBo=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.39.0"
      "sha256-V9cGwQuN8vJTENA/8Tn0+C0s08VcwuH0ZngMUKh6voM=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.39.0"
      "sha256-A22ci63beDqQdi+POVH71LQ//qLZPMksMDKYkIi/cRg=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.39.0"
      "sha256-2JL1gN5+ZiofUpo+tu39yC41B1Xhn7vaktDVaGF5olc=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.39.0"
      "sha256-OV9iSYwKhK3swHMjEPLld/YddXvHUZ4NBdxqgX5bfSY=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.39.0"
      "sha256-ueUcN1RDYQb6PIb9dKPaarj+BSVOF23A6HETF/4znYI=";

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
    buildMypyBoto3Package "polly" "1.38.0"
      "sha256-G7nQlatFX1liluz+6ZPhZZW0SPWDcllPcODHsZJTay8=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.38.0"
      "sha256-JNXmI8uVkxUdOzu1PvNhDEVh07EaLcv1tj227LPnkX0=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.38.0"
      "sha256-2atVs2RwoZ97crB/mmjk9S1X23CClMHkJF/Q3/UmrSs=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.38.0"
      "sha256-H8fPe/MPZxP4cz/oneQaZK5DPROzJNcgmB64sNulTgs=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.38.0"
      "sha256-UKBld+nE46MZiJhlbY3tbiCxILSo/TEjhDW4z4jTdq0=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.38.0"
      "sha256-mQBTT6IX9mssBGnpCYqq2oKNHfjereOMRwVYsei2M4s=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.38.0"
      "sha256-pdJV8F0TUjXeNjd2oiGiCVoCU6MIFP8yi3DHyqFXBwE=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.38.0"
      "sha256-ZgecmO3dz66i2COSXzBjyUCtTkGGi9gnvb/HNNEq1AE=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.38.46"
      "sha256-whlDNePhHOovmCOB7PN2/WbzzvrgQ0zvQWbscEkcALk=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.38.0"
      "sha256-SfdpEwO4k6hUOcXfx0TuF73OTKJeE5NjR4dyvBQWCLg=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.38.0"
      "sha256-NZgari0sOX1xG6GkI8IEKj1Y8aEA/RJS5SayoEGcSvw=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.38.0"
      "sha256-0mD9aI7KGbbjSatIn2kqN7cqN05mAr5FhIaXAi6JM2U=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.38.0"
      "sha256-Z4KREvXMPN874esEY9qY9dKfmscBtiON4EnU5fsuDxs=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.38.32"
      "sha256-WOx5+O7MBfI5WahylTi9gQf8XO1FF7k6f7/zWwznHhE=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.38.0"
      "sha256-xJSQ4m36XC98qB7wSgKcjIK4knHvf7pL47xxIiKInsc=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.38.1"
      "sha256-TIahRC+cMQXpduzw6iQmBRXh/l7vDNsLAf0OlxDPSCU=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.38.0"
      "sha256-gwAooRklWfrnqsapzp8/citvHLScqD616HSOSLv65NM=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.38.0"
      "sha256-X8ddsKqSKjHX1NexWy/Xk7i1e57vndg39XX4R0Cv/64=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.38.0"
      "sha256-RAibNhwfXcELRkkERBoUd1r0EhOHBPiWWnntVQZTbvQ=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.38.0"
      "sha256-cIDEjQGl23GS6AY7A7+02z+XwMCrYoSYIWuYoBxKje8=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.38.32"
      "sha256-Eq1JXjifzJ1r4TGNd3lJaBrBSTUiuodbjKkQZZWx540=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.38.0"
      "sha256-yeDqUgeNjtj1TpEKO+1d4DKGPfL4p57UnCyPC43HG4s=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.38.0"
      "sha256-yTy8wqNi/UphsyWAIm4cShZCH2lXXmB1NOUlEMaj3fg=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.38.0"
      "sha256-RjGqKnY21mkIdDsou/xo4ejjrgnMpknfuO81eGM1jkw=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.38.0"
      "sha256-URJDdSfpwq2lfpdnf5U4CpQJpZTtpZswc0lODkb2Wfc=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.38.43"
      "sha256-3wX/Uq4G/Uz1wA2kZgzejqxE5QFiZpyozM+XpBnsO4M=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.38.0"
      "sha256-gBkjxkSmaolRcBzYEbUwRvaZpEcPSD4cmfx/mi7VPM4=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.38.44"
      "sha256-6s8VyRZOVuy4anYVKttBTPj38itGzYCoQ/a370GhzY8=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.38.44"
      "sha256-RiLJMsOyrGAWZTKQurPQe7ibj+iGqJPL6QizFCwEZ68=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.38.0"
      "sha256-lBWZesgIKYnjSjUOPBhF4GNsNSk09YDSEyX0qweT3iM=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.38.40"
      "sha256-cvRmMi6lM1l7wZGN99HmSqOaU8UyLP3DEQCgEGtAUvA=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.38.0"
      "sha256-hyl0sFcp6zFl4bq7q+G+ySG7ZG2ZrQ2rvbZxvjMmCH8=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.38.0"
      "sha256-ijtnBR2nHtJOq/mPRNzXWl6Rf5fyGbmGCvVNGbay8j0=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.38.0"
      "sha256-ohyBA4g++d87WtfDCOD/ZYFvpjhVyW69ctOe3qLJ8us=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.38.0"
      "sha256-2O4up2TlzIDE7EnR9ZTpHrjen9RkJfjdB2HTntQXJQ0=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.38.5"
      "sha256-l+F3dFMiNlh3VahRtl86EDx31xxvGXLVkd/ODXN/7A8=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.38.0"
      "sha256-fRN+4v4/ByTxazCXS1pgqr7lhXbsnQxkpF1RneX17yI=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.38.0"
      "sha256-7old3PAOBcxk+WTKU59Wr0RgqDTuaDWoi/DtBCf6TY0=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.38.0"
      "sha256-3uD6pOOy2Godau+D8UhwPdBGfXNsdL4zqS1/A513wzQ=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.38.0"
      "sha256-5Pn3/7XX5ExWQry45oc01tvH3AG95wfwKu0LI0i8DCI=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.38.0"
      "sha256-731cU951zthFJM0ZjTmUjf5KjBRiKqKLLe4qwLe+X4g=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.38.0"
      "sha256-FmYQjnDwPk3B3kSTiNf6y3erojGgJrrAwyQPwn/TGpg=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.38.38"
      "sha256-WBpEvoDKvQczE/V3r5jcGDbKtmAbBK/+slY7tc5tcVE=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.38.0"
      "sha256-Z3lZTL6mDdqFYpCxau6KhhRVvj3V+aAd1t+ekzs5VLQ=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.38.0"
      "sha256-7oaAwnhk493zZlzZF6VL2rd2kWIw72ojUI7sEgwauTU=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.38.18"
      "sha256-93p1eVFFroBiRwpBWJMSa++CyP6/I9PaMFA8u4qHvvk=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.38.10"
      "sha256-usT75FXjlu2YAmgLrHVJWISnPmPXqgrl3aq3sPMamMk=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.38.0"
      "sha256-3YYgA865wTCleaRD2Am9H3CYQ0wrsT+RseOUhs678Rw=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.38.0"
      "sha256-2qsMBhQVTd5yzGhcX5mH4S9PgOeBXxE5/9wxcukXpMk=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.38.0"
      "sha256-F0Hjy6zoRUsSHZPSLUnII4vpVeudtgL2Vh1CIqbj3zA=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.38.46"
      "sha256-7+u35klbbDjPFUmDO0+PiJsSuDEgYBPZ0R9Bqh1JWkU=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.38.0"
      "sha256-I5wS2tRE9Fo9+gJKLgMP2gDA6BFqF+CsJ+1PCCm6R7U=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.38.0"
      "sha256-aIdfyQ3tVN3G+XqqF8fFHRJBpFnK2E0TUyLeWX/5+Qs=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.38.0"
      "sha256-minznoBq6k5/vRzDSOETy6/SelTZpm+V+aino+E1mhY=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.38.0"
      "sha256-cwswYTKcjKq/L6/nLYJ74OQ7pyZNeMxN1yHQWBpwT40=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.38.0"
      "sha256-y+UNghmFC0O/SThTVVFM2/lVF0KOgYVZAvhBZHaI0AA=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.38.0"
      "sha256-zXeQTNSej3dBIUEAysAwjj1v94OZWBblb2AT/1a2oDI=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.38.0"
      "sha256-Dny+ycWR2w48WsvjrTxH37DljvlsE6rUnCfJ/eo9Rig=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.38.0"
      "sha256-Oa68Ehov4g+WL9g7YX/ZFgA2Bdb2hR/fGVM3oKpCj+E=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.38.5"
      "sha256-6Vu619L2tISbyUbrm7zB8TTL2q+xcsNlvt7NsxBO7g4=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.38.0"
      "sha256-Hf/2GGvvWjuGBLQk3Mj8fs0LxwnIAri7D1AF9siO4a8=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.38.0"
      "sha256-ZREA1Mafa4YcJGkXTZkcUuLsbE1bouK0lqk0zBA2RuM=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.38.0"
      "sha256-dZ8w8h6UgZpknc0lTMT1cNgG84uMmgQcptwxZ8d8z0Q=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.38.0"
      "sha256-qiG1fAHlB0AfSzdQXaLWpyQW9AB2BUfU/aUWW6NbKl8=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.38.12"
      "sha256-RU8IFZVVcJeO4lRa9DG87ue5YPhkqtJB6qjBKG4FZeo=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.38.0"
      "sha256-ogK5uKB+Y0nj/gTGPKoUV5BjDHlXLXyTwKq8Uvli0io=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.38.0"
      "sha256-sBAiZcSfoFN7210hRnfaiXN7eE9X7AI0DXIhBSgIipk=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.38.44"
      "sha256-r738q1+73HvnPaW7x8dZjjgMbQfvu5GeoETvdFvL/Ug=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.38.38"
      "sha256-cIHLazKuWtTttl/5zstbYlFmdH28f0fuT2t0REGmQ6I=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.38.0"
      "sha256-t68nmdYyH2z4C3F9jdn8zpwewF9r8oLYscbCEP6hq0A=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.38.0"
      "sha256-RNW2mz7JuCZiDHr8n1VG/rxbuwh+a9i8lhpw0dEFpEI=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.38.0"
      "sha256-b6TgvxWdQI5TAI/OsJzmzlte1v30NdJucdedKgCb9LY=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.38.28"
      "sha256-demumYyUtBHj8Gzmml5374UxOLyWVMa71rN3pq55hDc=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.38.44"
      "sha256-0ptHkOSITJbSVlDKmH7L0ov7VysxhQEwHS5tl7TMLEY=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.38.10"
      "sha256-FYUbGPt20ViawEF9UD3iY7US0JQcSavXV65vm4VvHwI=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.38.10"
      "sha256-Dbihs7mHeWkNzIMMgmxArM9OfWJM5FgDEc2VOMLaT9U=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.38.0"
      "sha256-X+cq+zQQnUm/8iusKqzkKzVUSFDvQYToiEwRb4rwSGc=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.38.43"
      "sha256-yXbTYHv+DkozN0M7Q+wGQLqk6lA7msrhtXim4jrwy7k=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.38.0"
      "sha256-hOYOD8l0cDGKr3FNOSwMqGby64O6wmjHAL0F5hlOOK0=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.38.0"
      "sha256-ve7HllAv+PG6jHRZNp9Q32jpIEkCapOB4xZdpPYtZJQ=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.38.7"
      "sha256-fItaBlx3eeWHkKdYTSTeyUpTTeFc3cZdFaHBGVx7cLE=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.38.0"
      "sha256-14FLT6BCvEfFoS86fvtrbgu77Xz/doFjNtG+il5/o5w=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.38.0"
      "sha256-P23suQ3AHshp/XlqiCvi71/EzAdev8dweHx3PXkKFPo=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.38.0"
      "sha256-HyjR4eOXamDtFrC6+AkVT7M9Ecux693eB08k3unuixo=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.38.0"
      "sha256-ndTROc1T2APmQHL7EsSeU3XxWPYzp1e32tzqe4UDs/8=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.38.38"
      "sha256-lFNkDBG7ddnNFg+JWiXSSsKSLOrsZCTxMCBHKspqkcI=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.38.0"
      "sha256-RzqZdCtCyIHbj8W6JSnqZs1+VX+LZzEH+quRqQsoQYw=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.38.0"
      "sha256-Sba0SVz57DTuHVLm1CN6GAscv3QpZry+QMM8iTHyED4=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.38.0"
      "sha256-ExsMz3dqZVd6qtr2khTqbaFpaMvJsaph63rh7/QCsJc=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.38.0"
      "sha256-ZP8DXd3ab28l3szBETpV22PNZ0oS83H1Ogs9Qpb8Yts=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.38.0"
      "sha256-naClNCiAqHalhT/+8cI510kBzYxpY3Z+wppDpQbZtdg=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.38.45"
      "sha256-gXdxhks4bCT7KuXFQvJsSfe6y4aMe77ljOaluLe/n9Y=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.38.0"
      "sha256-XF/GzodpRAVz5IZaP2tQPng34aXFvF0XwRqdzabMHIk=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.38.0"
      "sha256-E9rdQr458LPhOdPToAIcJOYX1n64sNCdrD19d5WzA4Q=";
}
