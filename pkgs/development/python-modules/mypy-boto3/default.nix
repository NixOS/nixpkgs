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
{
  mypy-boto3-accessanalyzer =
    buildMypyBoto3Package "accessanalyzer" "1.41.0"
      "sha256-XD1ljr5lXkic+ZEXWCE0AlJaeKTbx/dqzVRCfVF6FRg=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.41.0"
      "sha256-mMujPNe/GOUYJEuxLN+tCjmaclrwgrZhytBItsiejU0=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.41.0"
      "sha256-0rqVmcs9qpZ9FtmsVqDNtmFEsNzvpP5UKcwKkPZLkvI=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.41.0"
      "sha256-F5z5katpCfMz1oblJHdDVgzyUvzlSGcvmsQf1gdSHx4=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.41.0"
      "sha256-wjH55hDXgHzucmlk2RToH5njm+1JGjWHvbSKntNzHa8=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.41.0"
      "sha256-UnRz8ET3HmyH9SioSYHmoC7zuzRf4IgBgicRdYPjXRg=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.41.0"
      "sha256-6AasRHvzMnvoj0tfZX03H4M8+7LazUS9czLFCYaqrXI=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.41.0"
      "sha256-r7qGUHHpjswTrauKY4XiowbZATmDFDo801XpW32mUwI=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.41.0"
      "sha256-U4Rrx/s9O+Wh6S7PvkUog6rcM4xiW8qgt6CgdmFrZWg=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.41.0"
      "sha256-I3ZhF9Dm1v+rcL2wtl3B3I08schyrB2ALvNKujgBUok=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.41.0"
      "sha256-CyvkqMZqe0NQN86NlRnkThc9APTd7RIhS9T8ezlOQ2E=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.41.0"
      "sha256-ESZeKbU3jgqmHpgMAbnG5oZHgzuYQDkfT2mhqamNlfA=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.41.0"
      "sha256-pa8LMyNFaRgcByLRqExCh/T00e+vz0lJr9nMYUQ+wSQ=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.41.0"
      "sha256-kqqiBj5RPasumOgDC88cgytek1qnMVvhWW+NwMIyEy0=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.41.0"
      "sha256-OLleWS1SYn4Y7JFnyiixKUQoFxpMcwT3I/ajptABtPw=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.41.0"
      "sha256-fVuJ4Wu1G03ukgnw12E1UBvGT/2ORgFpCqw6Qfdk3a8=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.41.0"
      "sha256-z96/hxoHwQFZF2PqUUshHl7Hxnd2YspUIk7Njikv3Tg=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.41.0"
      "sha256-PGsUW2WGc1ZCiDi8iROfGyeQP1qJvZrB3AN6R2jDGik=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.41.0"
      "sha256-sq5pRanpdlndSPclW2q68fQc6HZbTu3olMKd7cysglw=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.41.0"
      "sha256-QUXVCzCEepuKIHNYykP/IRWZEZSkOF0a9T37/CaKGhQ=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.41.0"
      "sha256-HHh5F9fl6FUiLN7TYWr79qekw7+RgrnhvHQQLc435PI=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.41.0"
      "sha256-hhm8V0Rth32Vxm+szkkm+MAIvIKBjmGJasxuyqWesOc=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.41.0"
      "sha256-BdSsZWN0HwLcpUMH7xsIxJx4loNQyuvzMOTi+dzsrDQ=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.41.0"
      "sha256-/hOp4fR72GY663pXVcCTcqSR+KSNzZW9RO+l1amQOxg=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.41.0"
      "sha256-93qpy/KVN4W2ronPxOAll09kRkko78qzsa+hQ0xOI9E=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.41.0"
      "sha256-GTFJ5vTrn2cesnQaPzJzXb3Zd53rzDOA6LyH2lprvug=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.41.0"
      "sha256-a8Z+OxMamZn9fiLrHT55EPqdA4QBhz/5NOqY5DJ6U2E=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.41.0"
      "sha256-Y1bZsWppIJKw3fkEhVz+uEm/JbyY7Ot/ysKnwH9P7uw=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.41.0"
      "sha256-++Vizo1wxUQWWylXVzBrR/3c2Y7Iwn/2dW16NUGTwQY=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.41.0"
      "sha256-JMDwYyH7eehFgJAqJJv9T2nfLFSQ7kdveQgJlHfUDk0=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.41.0"
      "sha256-P75YCwSwc7/H6TIHWD21iNtU8D0MLyfbALxR86cZvC0=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.41.0"
      "sha256-RW7RKSjeP70MrVWw7Ol5b17FMKvm7E6xHcNh0lwQY4w=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.41.0"
      "sha256-2nufCU050tK3YSXvE7+ZgQZ7+WhxUxdNnBDlfvxggD0=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.41.0"
      "sha256-m/PWIW+w2Jr7PN0topwKDtfOWcyt0A/PiwqRanuQKnA=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.41.0"
      "sha256-mYDSDzErl2lmozsOa8yyq9oTejxrAHaDFu7oIyF85Ww=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.41.0"
      "sha256-6NTv5YOH88yQVGgMd7vFxey6gk6jRU/0KD77JXJnTT4=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.41.0"
      "sha256-3Q7fKmuzr1fGp56N3NL//VVdHOakWkX7cDFIiOITq8s=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.41.0"
      "sha256-SLBcjUEwy1rD0UreeyXZHuLZFnWU7Zvs3ff7TmZyZBk=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.41.0"
      "sha256-K2WlBhNVSBSUQmNTPw4L9VHcbtl7fkDeCuMCmfsqPXI=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.41.0"
      "sha256-TIK3F9QlxNzBY5DJPEgC9fkIkSocdoW2kzJh/wH0ifU=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.41.0"
      "sha256-lQVqyJz84EDWsz2642R5EiCgyPeN75ZFVnvsnES/q/Q=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.41.0"
      "sha256-AfBPPCE59FRCoCqfDxizB3PLcsi6oTRxKEGdkSGHYrg=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.41.0"
      "sha256-JeB+IliK4/laFOzw6zd3fXWgr2CUbEXSpwyOpOUmf40=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.41.0"
      "sha256-D56b4KcV0ZzmmUAKWSp3akGArKxtz3PJyYaNcRc9c6c=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.41.0"
      "sha256-aGM7lIQdFvL7+2iQ/uPSpa9l/TlmseizBASF+06nJFM=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.41.0"
      "sha256-iuHl3slhnfM5R5eFiQwzX8N/Tki7CB/GseC8drzBj0M=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.41.0"
      "sha256-AJobxl5lk6qMCw0jaCe50Es0dne5tFvg2Y1AsVhRIkg=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.41.0"
      "sha256-oPD1K3BUsr7c6HRUgecbcGbruIT8TMM6N5AzASJIWJ0=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.41.0"
      "sha256-dCyto6GoBchftI1iWGmxjLfasLZLkepwalsJez6zMZU=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.41.0"
      "sha256-ufPuVlmTFCGtFgIEUO4mtOuy/Jl/82Ed+VvKnzFJOHc=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.41.0"
      "sha256-A/9+Pz/wgy2k7tcQXhp2VduZbXVnAh6C8vJ+sneyckE=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.41.0"
      "sha256-1Pu/8nnFxtRvJiHTUnv672m1/asEeKunpWK2RDGDlFw=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.41.0"
      "sha256-foMvPcxeR671VVpN7sbDqr1N9erBnn5A6Xa9UTCxVAw=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.41.0"
      "sha256-9/CqS9/p3mc2iMNzz8lWDXUmnf9/+unVqxjOdB7KAxQ=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.41.0"
      "sha256-zCCzxKlgqb6ChqsBuee0b+lwKBc9781RqfRLi+TH3Lg=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.41.0"
      "sha256-3lzzOiqccjeimq0brMDcoO5FzMf5ddQ+J4MlPZc1FEE=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.41.0"
      "sha256-3HJmodW9yc2fJCXzeHjaLMvRoRESsCS/Z96YfZ0KvTk=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.41.0"
      "sha256-dgVkLeC5LPCK6E+Ji6WvbuA3u7Rk1NNEM0cPT8SXtIY=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.41.0"
      "sha256-v4+oalesjsdLfct3deVghM987ads7EycetmGO7IjigQ=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.41.0"
      "sha256-iar4vSx4dlcXvsJH+sVe42DhzkFIgNuR64YzUGbglUU=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.41.0"
      "sha256-w4BbIBurj8hE78RUtWdmLekEPOiHBe00cQGrRLa7LA0=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.41.0"
      "sha256-fpIUzumcbJa/aM+JrsiNcY69A3lHLfogZQVj8egnhGc=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.41.0"
      "sha256-Hoel1nyEKB9hC7/Gd4zYhwDAXgQhCExrjAc48HlHakg=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.41.0"
      "sha256-/cLI2xjOur0PG9zJrPDpQjbmzUXUSXDmSCghBHS0DY0=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.41.0"
      "sha256-ig0uezjHHO+WwkIimc5ETQLm9xJ805LBAU8Tb8iRStU=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.41.0"
      "sha256-JSeLPMTt3N7/BmW3HYpjaQTnyDteaSZ6mKGWeyO/z9Q=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.41.0"
      "sha256-9MCBpnk5peEGatBczFtD9vlyMjKGPtrJwGs2a+yggsQ=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.41.0"
      "sha256-S/GVoK7BcnL7ZCzCiq974tr4UtJjJM0/SysR2x14jkI=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.41.0"
      "sha256-hfHr98Yl2rytJLs/VsoDEmBtT7xy0N+JONVlOhnkXxY=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.41.0"
      "sha256-9Y9OF18s2axyp0PTKD7azjTTq0PK34OkYeXPlWSYdxg=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.41.0"
      "sha256-S50+Wjro9Wzcq4PvaUbVfwxj0CLLqJ/Z+4D/qr6ojq4=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.41.0"
      "sha256-sQf9PZa1RxwsUx7iYT5Ynp7mH8yPTKsWUhAkGdcXIBs=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.41.0"
      "sha256-k9B3lZ309sQWaq0DoFiRwS83MChgB6pAcbUDq22m5MQ=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.41.0"
      "sha256-5iBb10gPQNYPgt0IwSv0JGuhggNUOMLS1dZRLCaDxYw=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.41.0"
      "sha256-Z8qxCDS6UKfJGv1N0rDLclxKzOeOZ3Gnfx+Ad1/COHA=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.41.0"
      "sha256-iORERENrNjvOYq0LHBE3Ghe5T67bTP0g8hFCFYLbOQk=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.41.0"
      "sha256-FSJZT6BbCIuE+a31a/Wr+OKYB9nKM9z6Y5IAryf3ZO8=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.41.0"
      "sha256-p9KnHxW5Rg+0rxB5Z+tYIfLCldcM5QtnIELrWJ4q3EQ=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.41.0"
      "sha256-NTY7p2y6QIgEnPzdil1c3QoCEcohTr86XeO738ZoQaA=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.41.0"
      "sha256-qXwDPmSOhjDEQ3HTHBCIB2AXTq+U25N7BG8InNlmhHs=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.41.0"
      "sha256-YMlWDdg9fW6vfRIAvqtMNgGV/HiatfnSGjFjLdC6HjA=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.41.0"
      "sha256-FyKWgYrC5HTs9KHOgrfJR+TF/0U/aAqmF0uqiAA09js=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.41.0"
      "sha256-e/bO3WVgx9LsA7qvlI/A26pqwtREkyB9AMhRiqxPNE0=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.41.0"
      "sha256-AG2BiSvd3Z3bhlT486OjiZd522b7rbTi0BJBZP2w0p8=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.41.0"
      "sha256-qxlAzYN/IXbXKbbNQS/zdEIY0bFba99jQVXkhMrurWo=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.41.0"
      "sha256-kA5DMRWtDouDlnmbeitWxzvcqA9wHVHgtouDhuIADXc=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.41.0"
      "sha256-Ie1BSBlKkV79MV1qeQPMtlY8ZJEEdM2Twj/vhXJFbUA=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.41.0"
      "sha256-IwLzheEJQ6D4CUHq3XMkp91j6a9paL81shof3t/vRzY=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.41.0"
      "sha256-rqWJixdcRZEffK0eT9hsopuCQFE0uH2ox1KQlaTG5Js=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.41.0"
      "sha256-GHSGGq7UGrHAcRpHSFChadVY16caMNr6KjxeRJsjeOQ=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.41.0"
      "sha256-6BsKG8DMvuKMgyYyoW/31N03czHLTFKzb5C/DCVZMBM=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.41.0"
      "sha256-DrFRqxTu7Yu3WL9vsJFq4GM9jpraP1hY0riO2gSAEaA=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.41.0"
      "sha256-Lvoc8yEBMYLQNNnnEbdL6GQT7pPV9sDL6jFtLZusx90=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.41.0"
      "sha256-/gYazA2cNVEyqBGPDbdBFP61Rnzqlrv0Oi3+u05vwKQ=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.41.0"
      "sha256-X6xndf0ZAgpb1ha4JnyOfG1k30kxScovKBke3HsvEZw=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.41.0"
      "sha256-kglgRTZaW1QEHLnwYNIV0ouS2Lx4TTGF4m+nMUUpXDg=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.41.0"
      "sha256-4WsEvKneH26nKcjovKFNDRSynLVrTB/WJrZ0WgenLqQ=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.41.0"
      "sha256-juYy/1f6TuCecLxtt3HLwrvF2eBXoYnK4xTYxIUiveg=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.41.0"
      "sha256-8fFnQpctLyNEZrsKI94tcpy7XAN8+ULGsih2oihHcyg=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.41.0"
      "sha256-uvqn0Xx2IooWG+PUvPAh1HmEKaO4SfDyqOwhe0sYUPI=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.41.0"
      "sha256-PXul6J8PEk8SK2lmMr/mAahpJQ6ZIWCheGGKs4SuJYY=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.41.0"
      "sha256-cVB8BDcAj7fGHNXPJV0x44UD4Selro2xUHC1tmg7JwQ=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.41.0"
      "sha256-O05+5uzp7lmM7N0jvVKgZuvnqh+zz6HiSvOxtKq56sg=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.41.0"
      "sha256-MLI/7uKh8yvEVeUDU/Sy7DwrrT3VBqGODx+zNVIcGVU=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.41.0"
      "sha256-kjrdAMALicYfFFplSqH3gNeq4LcIOvrmRjZ9RFhuzwY=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.41.0"
      "sha256-tqb8w1C7IDbdFqjiiMx4i98KleitiJldqSTTvQkmmmc=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.41.0"
      "sha256-/UrRVuhXc2FjNvAfQ+tnBQYXrCS2wj1cd70WPA1Nsqc=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.41.0"
      "sha256-dkQi++Vlle+cYsciHnVxtGrN/3Wk+ptZ9vYYsVrDoRE=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.41.0"
      "sha256-A53fE0Pi5JobG1nk+Q0BmlKIy04knkcAKrEJz224kBg=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.41.0"
      "sha256-Qxp3B2PJ/RKE+n4gUxnalGIVqkdB8Ta/zHyJ5lvtflM=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.41.0"
      "sha256-k6hbyZO+uRTIbGiNxm87Ybc7i9LCQ6CIrZj1nCg/KNk=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.41.0"
      "sha256-c8dsPpKA6yVGIbfbRh9ST8zQTRsLu7wfC2v77tOM6q4=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.41.0"
      "sha256-PY8686HV2+ARjB1ZZDtd8Z/7jyEmw6Sc2Rr6sk9VvoU=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.41.0"
      "sha256-kf8IlWAcx/PgZT5lsJnQOF164Cc0kscje/ai7NCAEyk=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.41.0"
      "sha256-PsOdXDBhWhoqYguYQ7LPTFMO4vTOaPqW8NuqUToSo7s=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.41.0"
      "sha256-wXMiX8YIYmWyYCegt5kY8vJSgJII4lDUQWTRbk0Wnq8=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.41.0"
      "sha256-J/+rSj7h7kjFMikn25IO7b/6pGGhFRTZ5vmRUPFkQvw=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.41.0"
      "sha256-tmSa+gqvJpOI0MlVcL9InKJD7He8rmXq/DAAH5pJdg0=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.41.0"
      "sha256-V7LbRsfHAgqNcVyTJ7nuRQJbj31a2PWrVbSxiqASxlw=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.41.0"
      "sha256-fA84JUJjVkcYZEcMOhTGZpHwHm2L4sEppKzl7GxAP9s=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.41.0"
      "sha256-+qwyioVszY06WCsz8/mOKL4h6AmTK69Dv+m8DcM8qTE=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.41.0"
      "sha256-cA7cj12JZZQ/w1FbOIjrK6l7vPmGCqCPp3d+xpgo2eY=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.41.0"
      "sha256-7z5KU5LQfIvshh4aEtTy8t/SApsczquNK0wLEmu1weI=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.41.0"
      "sha256-FCblXzJG3xztKCa+NYGKqdMKkJ71IdXcV8EjS8B+2ok=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.41.0"
      "sha256-MYR7xdRgdoiZi21SMAr5sqSdrxdgmH0HE56x2wJ41sA=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.41.0"
      "sha256-JacU0+evD+6uNfzub/BZGBR7YUB13zCWreIE5N1GYTU=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.41.0"
      "sha256-Ai+X0EWcJDTRx5YyYE2hbdqrum/uSWiy2Xczu+NL9rY=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.41.0"
      "sha256-2+jL0ic7vq6AAQLXhzTy3ZdEfWVQrLTFq0fvMGAjf4I=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.41.0"
      "sha256-3Fl97pRM53uuiVn8ueiFIqhok6oNHSwXkRabkIF7eAM=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.41.0"
      "sha256-v+p1OJoW9sBuO6uXlRolDD9Kk3bksb0jXLYSpzeR8U0=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.41.0"
      "sha256-uV3/B1d6VMzyE9AsFJTKYyW0OBnWgISCbU3bjX9zqxI=";
  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.41.0"
      "sha256-VxPgHHmT0p2YQuCnVfi7pNIFuUEaNCBJkghTXqP6e1E=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.41.0"
      "sha256-zN/xAgxi5AnoXuEHsQqD9C5qQagOlLoxokJjcQTu/Cg=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.41.0"
      "sha256-RVFTB6U3pW0Z0S0Zvo0UqtHWoroQ67tg4PkW+c4yHKc=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.41.0"
      "sha256-2GR2YSsl36BtoBds+ued+IS/I+rQ7DPGMXL0ZmFVmvo=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.41.0"
      "sha256-pPhSyUcoigzLnmFWnTNfaAnp8C3XBwaMgQTmnpzeGDU=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.41.0"
      "sha256-zXP6qyC96ZvwCFtdl1qU/yuedTu3UkMsaiqpcDKzwrI=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.41.0"
      "sha256-k1iU7LFubjgXvdV5rALR7gKTqD14aVPJD9eU9E0sJxM=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.41.0"
      "sha256-/myZfPFdw8Lt7ubxqK+XX6ZchkMEQhmO9BJcaYA7DL8=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.41.0"
      "sha256-WsohLrGnt4ZMcOEdjbjK5057XeLwZ0ujbJD8AqajxW8=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.41.0"
      "sha256-gOFH/0ILcXgIW+2eHIFoDcP2MHggIDKr6M569rGycuM=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.41.0"
      "sha256-otIjtY7S8nkyrh5HBq+ab20toGzwZPP+wJGie1MCu3I=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.41.0"
      "sha256-sIa4WY0Hx4eHN9gesiCkAjDTfh1yuuzt2ad2rzGCXfM=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.41.0"
      "sha256-IoGPUHDP4VZNNgUmVaJIPKKFYjkSHx3KYkqG9mLr/2g=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.41.0"
      "sha256-/8GwJ1D03NOALWKr4fOa3lCvgyQNePatBLNTT5Eyc2c=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.41.0"
      "sha256-Q7WBaxuIKSDDRdjt7mxiJokl8q7pbdBW0qh3oxC6f4I=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.41.0"
      "sha256-jNVE+X0TNviEeq90M9mhfL9G02njhOgT+c6Kpw6nqok=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.41.0"
      "sha256-Hj+hvG+0Qi0csGyl53ei/o4wvGDSO1lT9Vl0RUDBTZU=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.41.0"
      "sha256-RZsmFaYBfcYeIf+hon6IuTVk3vwtijl/+vdy2l+EcxI=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.41.0"
      "sha256-AMvSmqphAyldR8HfVh0dqHyo4gR/gCXKmJS2+TTMUvo=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.41.0"
      "sha256-E+Db1QkBCf+P+a74Nuj4HzAYIOsg0JKdDNJlUW5WU6A=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.41.0"
      "sha256-V+6z3jwSclpL2hOdN/EhiZwvRGHtt0U0+L+eYngVCjU=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.40.17"
      "sha256-SeJi6Z/TJAiqL6+21CMP6iZF/Skv1hnmldPrJpOHUfo=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.41.0"
      "sha256-wh8Yd6+7xJa1W6j9IUcqqrVe5kvxfmi412XntjMUBz4=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.41.0"
      "sha256-5cum+UOYhuEAKVhNw9b2c5R1fwCU899pxSR6TEHXwHo=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.41.0"
      "sha256-Q1WQMLiTqVn6cnuBKyt4VPDRKCm7HR5fZPDPWRnSz9o=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.41.0"
      "sha256-9lkekbxTKAXaUfezztqCZOQK8cWImXSg4prgNB7UluU=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.41.0"
      "sha256-s/EC6xEkmw4/uBMsqpHC8pOojhLHno2b/FUoCoX5JOk=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.41.0"
      "sha256-I/gqDPbuABc7k8vlBr/yiMASuxmABdjLCKC3UpHC3RY=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.41.0"
      "sha256-0qeTVNObdbKGsLpeiQfpButPGx0C3MmjPRgccVs/SMU=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.41.0"
      "sha256-OMJcu/aYtlUoZwBbrCB1jlzb9GI1s8LfHImFgeZwpLc=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.41.0"
      "sha256-xyAjosHBkjuTTAcJaK0Fs5XH/1FwlXM248H1n/6yfok=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.41.0"
      "sha256-beHMH1UcyZK38U3YKoGUshnDsN9E88BePC8spDR86Zc=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.41.0"
      "sha256-bicwSQt7UeIrrDN3r9UIIXq+vrct/6OTzTLCbUdeues=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.41.0"
      "sha256-vXKkol8Y9eJ4SNq6DPDCS3kbSJqflDVXtnbtxSP9rqw=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.41.0"
      "sha256-PRgARx35KRPjLj04Ux5Y2wr+Meoy74h4DvZI2LREKzk=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.41.0"
      "sha256-PMjUlZgqSulMtKuHr/LTHGPL39spvSQSBhyL3g09Z7k=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.41.0"
      "sha256-QXMKPuGxr+bCQlweHA+lHoKF3jBGG4cBJyX3j0LHUnc=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.41.0"
      "sha256-P3mAPOcC1K3YjYUyRJE/xwcLCg4YmfPeEwhU008st4g=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.41.0"
      "sha256-fwKKoVPu5Nho56zp2187XPPFdnvwawCOPKP0I2LTNFc=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.41.0"
      "sha256-d0Ycq2ECX/EPkRkDpR8MdOZazmdockd/KRZjXfhChGg=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.41.0"
      "sha256-rcsioNa3cY3ks7eXT0bc2BDb8DKIfO73pkQmfiPlQIg=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.41.0"
      "sha256-3PAXe2t3si55aKbgJLaSLajfygLwLTeh7WC+oZdKCkk=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.41.0"
      "sha256-DsqRvDpfDRnREKRIsoZgJqJDwV0Rly/u+q90Pkgn1Go=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.41.0"
      "sha256-8Blino0muSOiKC2uEF0LBSfNeGH97HS8M9moxxd7Kjg=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.41.0"
      "sha256-Wp0iq5lAgQwm96krIGpPzHUSHS8DbRtr+uFC15WCm6o=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.41.0"
      "sha256-EajE0a6k9p6XTui6nruNCzN0Ot5z4xS5ZL9bGfkb9AE=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.41.0"
      "sha256-ivXpG1VPK1hf6464B11caSlYN09OlnXMiQDT1HcftTE=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.41.0"
      "sha256-gwtx37BWhoJUBR2J7m/H65ZZIu6mBaY2xraHD2ndEvA=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.41.0"
      "sha256-hZ5eMRBsb+IkTUH95+3f4nGo1X5lDrrC54xJ1he/nO4=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.41.0"
      "sha256-9J4vNxBibnyB1I+vyIVJina3tMlWCdbrtSVN789eeXU=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.41.0"
      "sha256-8GLOqOph4BG3mFcwLVXZ4qinPsSi3YCYMQhgu5g1Jvk=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.41.0"
      "sha256-j32PWYxkTh7r4cB/L+JpYeddl7KU46naoy+ZI9kd2/Q=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.41.0"
      "sha256-7HFSwIvcnqZ5Vq266TUhOQCSJ4sIrJXTVqiOhXosjcI=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.41.0"
      "sha256-Urt3Xz6dPJ/YWHfhIdV9aDWRkOVkpf2kBE9wBEadfvY=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.41.0"
      "sha256-54woBoJfzBgcY8mR0f2ofJb96459Ay9wf9gPzpJ1OTM=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.41.0"
      "sha256-S9Wy0uqdlvqRmaheZBWFcHVFjCyhLuHmRb8Vk1wgpHI=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.41.0"
      "sha256-y4nhdq4Q7Z5kepbajnw9CQgmuwLFcjgqDMot795EM8c=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.41.0"
      "sha256-8dAMWt03PuP2x71cojBHCJrsH823K0GDDh1Iply0mr4=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.40.15"
      "sha256-ZcL1sZGlckqZFhCqTZwMeghP8K9Hee1Zi3N6wZb9hts=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.40.59"
      "sha256-MlMkIgzc2D3i5xAPdk+th0e9AYrvRxGwzl4zwEwy4xw=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.41.0"
      "sha256-JpBd1G28XCMH4SIVIe2IlMteHUoIgGHPC3Mk0vTQ27Q=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.41.0"
      "sha256-ggWgBa1KXaTBW+d5j/zOsJYCQeOLATVQI9WOBqw7Gsk=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.41.0"
      "sha256-x/GuTxCmBonyQiVfag2eY4iiRIJAU8wF2wD42KqhzCc=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.41.0"
      "sha256-qDp2gMiDH8lWAb2hp6rcNPqjA7LzeFZXr7BeH7+7EqY=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.41.0"
      "sha256-yC3MxqolwGkRX64L5FsVpTlPiFe6ptb2SWO1EyredXw=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.41.0"
      "sha256-7qSbGMs4YI04zFpoTG0OGfVcAtHm4DsNyRXIILyqOa0=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.41.0"
      "sha256-KrbfCp9YCOevWWD/sSLbGKd6ApbZmW3UplMJ4gw//IQ=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.41.0"
      "sha256-txzRpMKyXV/RlSDjFEIRo3mNxEyMrrL3f1u9Ca4B4p4=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.41.0"
      "sha256-dV9lOcM6ikqdM7IUjWUqNzFWeHWVTv/frhz8vyezKD8=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.41.0"
      "sha256-986D+wxw55j02cMAUBHAm0he9+NdDsLs4e2nYVgLy9A=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.41.0"
      "sha256-1B1AVdKrHQhBB8PumJJefc+M/bykv8lKSXiJ5aJZnA0=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.41.0"
      "sha256-jqFIJ5hR2cYhAXcX9s9BlHHpMP9P3AWC2AY6rcmiT3M=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.41.0"
      "sha256-uynBhFk0Abwv36DI41tKnYZ4J9NNKogdMqvD3+goUOE=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.41.0"
      "sha256-2jHaGwIsQmLNJLPOgq6WKTQc+XqklW22DP0hLGOV2UU=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.41.0"
      "sha256-X5FgqRavwD/ByxSvk/CgtGfWwQrAiNJFMGvRSBpqsfI=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.41.0"
      "sha256-a7CqBxBzk/o+CV3UOsC03HxhJbd5Qlhd+P6DaAWS00U=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.41.0"
      "sha256-hikHMXSPnmJUeAqSeIS+3lvX5kC4TUL29zFhcDFCGHo=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.41.0"
      "sha256-KwMivU8xhbfta4cM03nkySRZ3GRa606V+A9KE53RLtU=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.41.0"
      "sha256-cnn4QL7eeCiZWP0kcETuM+mCiz1rAmUWwq1TyZjoLXg=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.41.0"
      "sha256-BBs385Vpw868GOK19MjPVVHKvIb4lLbxVlL3h10Burk=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.41.0"
      "sha256-HUGiiAa59dNEnei4X1VSuL/WDCQ7bjmSVe8XHq1o3Xw=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.41.0"
      "sha256-ElyofKfCvljR91f2J7iOuv3P3nU/VOZgDwnSiWYsBTQ=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.41.0"
      "sha256-NgBYsKJDBx3Z2Csr33wOlNjBhM9ePQ+XabK/dEn1p7k=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.41.0"
      "sha256-xl2fDoIxBsppSGFVYVY+iSoQu+iZNbCUtjl0aGkGzQ4=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.41.0"
      "sha256-Lawj0aC3a7qiVpVbyqF5Gp+21YYzNC4HQHED+HC+S04=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.41.0"
      "sha256-twh9VUH/W9MLhaTmU15YXmc+NiJXxBewkVoabq/A0Zc=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.41.0"
      "sha256-RzBuICH5fQxnCov4F25gdgb+kqkle5hW+QYItNpo0t4=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.41.0"
      "sha256-/cYSCByOJe33oK7bl1KE8yCs0v/e14+YUHhk8Mjm8Ek=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.41.0"
      "sha256-iirAm/d4PWCP9CVgju+H0a6b4+heGTh8AkfBi3kQ9iQ=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.41.0"
      "sha256-7//t10AJ2n2Mb7v4p2uFaZ7QxN3G8WnuL6wVh1vAC0E=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.41.0"
      "sha256-C/z9M2aQFWjZVY34bz6D7PbUpkKv3qd7DqByt48FRnk=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.41.0"
      "sha256-0rtTR067/fJ9ZocM6QNDqA5x0CEqjO4uKA8WMB/wOtE=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.41.0"
      "sha256-dzcCZonHrc7Yt4soJUuhE4+tF/qfRaxHJWeieO/MmeI=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.41.0"
      "sha256-xuliXXmknsXPmuEaYga3w3fGQOAnXD3v8o50lRov5h8=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.41.0"
      "sha256-bHX9DqSjLCNLZhUzr3vs2TsarkNPz9BwhmltU+MbRJ8=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.41.0"
      "sha256-6P2X5lLIlBbme1rN2URwBNWebqrrGMRQ0ZlJn1MwjEw=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.41.0"
      "sha256-alP0AfHYAg6ICx0YExIGz2TPfCz5LRksvMMLUo7khMc=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.40.0"
      "sha256-ZuSVlDalSjVyMGVem02HklbAmDZXJeWnd2GBrMFJKHU=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.40.0"
      "sha256-JEuEjo0htTuDCZx2nNJK2Zq59oSUqkMf4BrNamerfVk=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.41.0"
      "sha256-Ysi3lqJvIEyE1KewQ9jfX71m/GbHpKTDKyZu4Om/j/4=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.41.0"
      "sha256-Z65C+xnObE6G8x6yAP4OF3p1ZuJN+mU/x5O8UdxSPHE=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.41.0"
      "sha256-RfCDnavYW/nVEn4wyQtqF8+wrx71kSR0Ztjb225rRdE=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.41.0"
      "sha256-CNN7vovIF4d7nExBmsrED3aOR3O7jtgUmszWHUx1xOI=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.40.64"
      "sha256-4jXXEaS2Uy+k+FQScXyaLToUC6E3+poejhOLAOGBFdg=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.40.59"
      "sha256-llgYHZUfQTOy5E4BmmA3gAvYi4Q3RjrCtfFm68ECEGY=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.40.59"
      "sha256-f3SQuBhNc2tL3vdqJmoYgnpUICkvJmENShpVbtE7cuM=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.40.54"
      "sha256-pn+Zpzpa5SBhnzzo1yVcQzFi3u3Wbf93AvOL4Xu+yqQ=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.40.58"
      "sha256-cSxcEUfHRBITijZot4XhvijEAfsPWlPu1ZGf6cF2tbQ=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.40.54"
      "sha256-vuOhtYDVqnB4Xn5dzE3N93b7ZWalyvPwTx01CHFzSNo=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.40.55"
      "sha256-PqK4IfA5JcI5Cg4ymR9uoTF3YLs6vu0l0Gl4e7af2Y8=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.40.60"
      "sha256-BizLajwUZznm+ay5QaW39lf61+SGGeR302r0OAWZD5s=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.40.58"
      "sha256-SRvim/6rT3H/OHT1FZRx6PyPUV2GGh5nk83EXhVi5gc=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.40.54"
      "sha256-3c8he41vrrQwW64aGB5ExykWVPqGfj73P0gZBYoqsW0=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.40.57"
      "sha256-n20s8GSpRLcaGXyPJs0KOUwGBOf6a2q22fe1kph/GUk=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.40.61"
      "sha256-o1FsYBeSdq8hcTyKZiCVOuS4XJYk8/8Jrxd+psm0UpU=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.40.54"
      "sha256-3qic3Zk9WZ1JF570ASGt6X6EBeWO4hGhs4kYQZ3RfQg=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.40.54"
      "sha256-5XQk+0F6fX80cEOQlHTZOpcbl2qpaAJOgqawem8kMpI=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.40.47"
      "sha256-BEHP+U37pdHVP7UABWkS3zUYNg+xE6Z/A8mmmd0/LmE=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.40.54"
      "sha256-7h7WswVMGPBf6WsX04+TXA3o8scarCUqnSW3dgUyadw=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.40.54"
      "sha256-YrrEKl3aGz//5Z5JGapHhWtk6hBXQ4cuRQmLqGYztzg=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.40.49"
      "sha256-skz5HFlXRIhqefMOSN8lvhmAuu+COBC/hl8YGJawXSI=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.40.61"
      "sha256-AJOmbZZ199Qtgc7s/TN+Mit2/cPM2dDCmgD1Oz24N0A=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.40.60"
      "sha256-8vUsRFYRMImJyNarFTFLdz0fzsQZLnLt/KV4AGaoQg8=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.40.73"
      "sha256-JeE4QXfg7dTqKQiJiFCEiCgC+GGmGYZuo0mTzLPZNNc=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.40.60"
      "sha256-tPhLjs0Gw9CunnNhnWc9UMyOwY7f1B9V/XzEHOOoLg4=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.40.72"
      "sha256-dlnL+r8PJmkmgGgqjGv4emvD4XqXClOv89krM9n9ydA=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.40.57"
      "sha256-G8yP5UD+srdmTHkuwC5A05L47Piun60kHoPzWG7MvGM=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.40.60"
      "sha256-gvWo0ybabdCa9Y16q85MTR3TIF5VvVJQ0zrnCmkyheM=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.40.60"
      "sha256-4kLiWKy5lNB4Ins3UdzdUOb3DWqonLF4HJWN9mNLmRo=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.40.58"
      "sha256-EHVAJ8ElONBpXvZoXfuL7UbHNOYZyZN6ABHViQg+a5k=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.40.46"
      "sha256-x1BJr6TZpO5OlfAG5l9PuAmfTAMtjnRv3SWO6bh2zPc=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.40.61"
      "sha256-ZKa2t6TPCQBID9YGi6vkYnw9icZQinedflGoqFyXqc0=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.40.64"
      "sha256-zcNW4Ll7oTzeZIL+fV7DaP/YYTjmSzvPhnDukyVFGog=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.40.59"
      "sha256-jYAsZ1lMU9cl4rIvRO1UZLn4nIsuauWrNRwyB0j4HK0=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.40.55"
      "sha256-CoF3Aw759lxUzg9iRCfKofDkbq/idAIy4Eu4L7yrRL0=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.40.57"
      "sha256-GcfGVmcrqgC3MAoqJWrzUXFDr6b9QeSTOP8uCBpnzCc=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.40.57"
      "sha256-EIwRua248SviAlBapRfoxIpCi0ydWw5h5keOZqMA2Zw=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.40.54"
      "sha256-WTZGKD2w3/OW41VKgk/l9KdBnggip8CDTesbtiK/Hic=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.40.55"
      "sha256-lz/yPloTNQOFgT7+FvkxQFFW1bBG+Ew1VVrd718UPDA=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.40.59"
      "sha256-7PNEZ4QfwF9yAl+Fl1ok3Md5FZa2DLO1RIVqIp5CiPA=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.40.75"
      "sha256-9zgwek2AThe58d4xBvD5ECJIXRx/PxFASMpZAaFmJ2U=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.40.58"
      "sha256-eZwpjtTCEt+DnFfHxJCVjBKDxA5qQkBS/1gk0zKb9ug=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.40.61"
      "sha256-JlXbFDyuN/vGi1Oq40+8XJBJJdBLDyY658OPtWC2qF8=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.40.61"
      "sha256-yyzFGMna0sVQnoc/xQSXTMO/RR1RiyQuWHeiVHHk7ZI=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.40.63"
      "sha256-AL/XZLrWVNvZXxHvFXCsR/7L0F+9gCS20AhyJOSk5XE=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.40.73"
      "sha256-+YQ79hmdxbA/j7jmbOibK14rjNZp1uEPFNstt/70QGI=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.40.57"
      "sha256-hM+OvqETv0u6Kk1ZgfzgNWgBTPamBH0oO+5W4hlUgeM=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.40.58"
      "sha256-jmK+l8D36ydnlSEHYxDO/e9XuMp79P1QLdjjFRcFn6w=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.40.61"
      "sha256-zlgDGfhQJcdxNYH7FIUpQJMQ9ytqhn0fbxRm6Hq+La4=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.40.55"
      "sha256-VtcgEoZH1zACZvNGEfy3gDsNVqa3A8JfwTfbd6agL3E=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.40.59"
      "sha256-7Z+kgd+6TYaE5cNmcJi2eWeAsCs0kSv+c+CLr3c9FnU=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.40.63"
      "sha256-QbpaTAAmqvN4Vo6vq3U25bcYLgTGZUTvgaxl6BGbxZQ=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.40.64"
      "sha256-o9l8b3o+Z+ft+t5UBUleHbOfHexY6UBUo10ko6Ru/IA=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.40.60"
      "sha256-ckZ45QZgelh3hVVmMrxdFO0I9qRs8f4EmmRizHB8MVk=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.40.63"
      "sha256-QV0qMR8NdhDx4WR3okTGpYvkosZfD3QslmegvvPyvZQ=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.40.0"
      "sha256-0Ih/hjzLE+pf9dXfTHLli5PYAyRGOTq5ghxNcpMN0RA=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.40.60"
      "sha256-KGx39Si4WoeFHsMTudr3Hmu/eafSsdDXYH2rdUdDbGE=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.40.59"
      "sha256-X3jJvfIkBOC2H85etjD/noBJAuQKuXuH5YHwtQg+0as=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.40.58"
      "sha256-bwX8OJWCayO3dpMuhB9VelSzhl/y+vVch0hY8w2NFm0=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.40.63"
      "sha256-zj7R0tvQvheGrQIAuXQsHBJrm01lQlkoCxkJLZDJR/8=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.40.48"
      "sha256-9lvZvist3G5plkmsvZ4iHM2iBim8V3BmCYTbk6xDrmc=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.40.63"
      "sha256-fKcu/kTLFF/SCXN37pnaKidNi+KxUCnF7FsKTYRucrA=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.40.61"
      "sha256-zATKH97rJDBSc14LaphATdXW0S/4peOEJjK3sSwDk5Q=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.40.59"
      "sha256-iJOjHP6nqOp7LtyEQe3ZPPQVX7hwplNk1BRG3RaFQNM=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.40.60"
      "sha256-qzGok36eKfk+Wmo1m7NEYVJV9GayCjqBT3P++pMK+Xo=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.40.58"
      "sha256-e5n43zgh7Eo0CO6p3m3hC86lk5eAT9gBS8aluLFYORM=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.40.60"
      "sha256-BHmfR+Kx9ZT/xbcXbBrYcraFKPbhZ+uc/1c+IQBiVLk=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.40.55"
      "sha256-B60F/Q2FlLuNCGZuxSZ3A9QSAMFMgFOO0AFLzmTdyoU=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.40.60"
      "sha256-FMOmmPRoZJHz2/U6U5IkMRmDd7XztoqKQKTVm3CAfeE=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.40.0"
      "sha256-ZVrH3luEpHwORa+1LNdmgju3+JUy9/F6ghNzHZUicBc=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.40.59"
      "sha256-n9fTVYvwyPnGIkLjHpALZ1nqZC6XrClJltHicNbgd1k=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.40.64"
      "sha256-G4DP0bpdEItLqe8nNyQIrH9YjaLsQulihQh85yT4nt0=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.40.57"
      "sha256-O+SB0ntnaEzGUHq/GJAE8tCPLcIaTcuWIJ850rv0Vz8=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.40.61"
      "sha256-FtNNtlPc8oYYtOQirjLrLTTz+Tfc7l7dTKTePducOFc=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.40.54"
      "sha256-V6L3DNfXgzQIXLp0ahUw+ILAw6QagJVcZdSf07V9Zb0=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.40.54"
      "sha256-OUZn5wWVxirqeyEIrPgIbBwG2ikudihKJo/WJItVkLM=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.40.57"
      "sha256-qk/18pIl23+NoiPHM39hFIhJx0sTxhR/JJmRf9ePpx4=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.40.60"
      "sha256-KPj/5+bRGnfGct08/e50UhrR14xm+HDYVxoM+U6ugec=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.40.63"
      "sha256-sNbfCSaPWCpF67SQcKcy290OSiMPdHpJsYTUq7uaeyU=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.40.60"
      "sha256-TtEJjbTL9jtHQv1GFPCq2Rli0bhmDCR0OGFZyYZjU2U=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.40.59"
      "sha256-s2zrJxGMHYvWUJCb+4Qn2Ot0qDLBI8wTPpGLy5iUzPw=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.40.60"
      "sha256-zDN+pmptUjq9Cnc6U7mmWqat6PiSWxJibgEuYq1P96Q=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.40.58"
      "sha256-aRgrg0Mpzc+gk2GIPjofavpf6IkMNW3kB+vU6aNelhk=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.40.70"
      "sha256-sBx6B7GRmo0Xr86FmeGIR1YfNVwS4qz18SW46R7P+gE=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.40.17"
      "sha256-Ngqg/OaZCigXIPORzWl8CMv64KPmu8axXSgnBzBWnII=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.40.61"
      "sha256-JRCWcVeatM6XvNH/Rdi4Ny2Clpt5L2aAQjVRRcyT69E=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.40.55"
      "sha256-zer2dqLkBLe1CA5I6+9DavQPvVLtrGFoxi50BRDOI3s=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.40.58"
      "sha256-naC16by9nRoZvRfSIIYJdk4jT/lxqUDeogtGb+q+avk=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.40.64"
      "sha256-KPHmg5J3t6O7SsukkdqnLiNxHpnbS81kPjCD5gxlrzs=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.40.54"
      "sha256-QXykPDFwDXTY44JyYNYRBvG9/rBVmtisFKrmp6UKIQM=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.40.55"
      "sha256-cdyFlcNg9F5RPYJ8xuLm1G1plHQDhRe2YQZqUv+wk8U=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.40.55"
      "sha256-Jzl2BKfgW5EK0GbjUP+BFqNOeEiFvlMMlgzaJxgaFzs=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.40.52"
      "sha256-A93BHo29EHovA2v+hACbOhN+ckTL8JAGgftBBFzXBfM=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.40.52"
      "sha256-Z00yi43t9SMR1hsAG5EkvjaRKLqUU4uYwdn3KVVo+6w=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.40.59"
      "sha256-JDhOF/W9hClZoQDlnYIfAKsU14jyCEillCfq2kqnhSM=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.40.70"
      "sha256-xYZUp/3OmWJOhaZDH1XkMYKTlJN7sigeviLNVsceDX4=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.40.54"
      "sha256-6usEXd0rpBSaLBKHawPIiPzqfHoNCGVO8c2p0eBqrvs=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.40.69"
      "sha256-pzWCGZbQ6idUKwNWxGyg45Z4rRzdReADX1u+934VmEs=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.40.64"
      "sha256-6hFX0XgzB+dMqyaEUJQADjivNJH71oD4KG4KulkqRjE=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.40.60"
      "sha256-bbhNpZd4H36Ai5o0HhLJaVTmteMwswzLGpg4huYXQCQ=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.40.70"
      "sha256-xN2jcBDaBrSCSreVg8S5mtN6tx6mfoyDiXEex8VtSTo=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.40.55"
      "sha256-oD/sVVMrRUBW5brBaCyNeNfHU4ZAWgfiqcgEwTxN00c=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.40.59"
      "sha256-ZNjp4SzprutjypEz2lNfVl26eaQa42M7ihnyoxKjptE=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.40.57"
      "sha256-12d4SbtVxKDSBedA1F2VnopqBKowjuIKboHZpIKEwAc=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.40.57"
      "sha256-S5/42kRGzK1BTxE8Sp6XY93kljykbQK0YYCwQM+sJxY=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.40.60"
      "sha256-tdinxlqaJt7S2m87xb82AlSB+FgrKSuFZKcGIfbNnUs=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.40.61"
      "sha256-/N2wHasgisfb8fVCiKsNecyTZRGF7e111qr95hYEIac=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.40.73"
      "sha256-fMytWYfB05TBtTGKAF4/VBWUeuEwVApBe4BFq8mAkpM=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.40.61"
      "sha256-FEAlQu+9Ghddr4peEO6zbhHM9LN6/aJZ/+tdMKHH8bM=";
}
