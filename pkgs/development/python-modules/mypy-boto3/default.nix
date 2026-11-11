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

      src = fetchPypi {
        pname = "mypy_boto3_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [ boto3 ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [ "mypy_boto3_${toUnderscore serviceName}" ];

      meta = {
        description = "Type annotations for boto3 ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [
          fab
        ];
      };
    };
in
{
  mypy-boto3-accessanalyzer =
    buildMypyBoto3Package "accessanalyzer" "1.44.0"
      "sha256-ZKjrVwhkuECLIa2YYfMqzhZKl51Yp9CV7l2Q8B2Lcfo=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.44.0"
      "sha256-Jncyct0wM9xOdJluWEuRuMNYnYJH+8dBuhCDpEs9X7g=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.44.0"
      "sha256-XqtK5TlfsVW/B8eAGmuGQCu0MT9g1AErvd+PFNkenyI=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.44.0"
      "sha256-l5ovX2iQacSSKHXbleQ9G3EpPBK/5ckTBapvpjLao6E=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.44.0"
      "sha256-cMpbZv/fAINdSaQUCPQ4JlkiHi0KUwqX/IrSTq8OIlY=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.44.0"
      "sha256-a3/aRfx8uvdk6SixX0LlModZZp7DooqdB9vjzRODYSA=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.44.0"
      "sha256-NJRXFhQ6qocoXe/gr79NFyIMbZPKa4G0D2k1NeGP9D4=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.44.0"
      "sha256-zN8eKHLqOIWxBKti84XvvjXuf6rIAOV46zmswFN7Ehs=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.44.0"
      "sha256-v24/hRXoCubY2DskATFYhI+v7O4uYKSCtGB1jJxEDSc=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.44.0"
      "sha256-GfOhCq/aqVMwY5jAVIUhKQlD6E9hG3Hgi2yWFxTfVos=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.44.0"
      "sha256-S0NGFJfwWuf/Rv7Xnol1uGDcXIDbckSJQjMtyDX34k0=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.44.0"
      "sha256-kHfcK6YeJzzMcjLOzieLjHF3YDpZOKbeFQm4vWT6w1Q=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.44.0"
      "sha256-QIHBuNdoUxZSMRWmkCjPFXSxHzx1/3n1ppOTkXSoT4A=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.44.0"
      "sha256-rNsoHTotxumn5u2Ea+0cF/BX1UD3SxEZdPcYWezjQpY=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.44.0"
      "sha256-pqrFqLQaaqgfT1z++EyHezwR8MUV7Zswj4s1OLQvF4A=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.44.0"
      "sha256-b8bnC/fq6HC1MTjU99ZenTCfpOC6EWAvqiuhTTnd6ug=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.44.0"
      "sha256-miQu4Y6egWNXvI57OPxk2T069LxQcEOkedIWJ//LQG8=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.44.0"
      "sha256-BTGmejwvF15bk7FXy+dtED23PFgFspFLsFcdFggsXL8=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.44.0"
      "sha256-vWDt4cXRP70sNeIUQqSI8wf8zRpMl74ww+/y6az+6Ic=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.44.0"
      "sha256-Cce7GjuIQ1+ygfHu+v0cD06uTrpoKlwtY9xaZBmSxkg=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.44.0"
      "sha256-lqJ71yBDBos/5y0fUH5qClF6nbaAz1/Xw01VjBtXuss=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.44.0"
      "sha256-XfrL1Bg+sEpoTfUZST3oI0JpSeDj4MgI4bDGJ0MQSrY=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.44.0"
      "sha256-nXz1Cd6Oeada/vjDQY3tlCcbPAVKmcw49ozgnnU8HvU=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.44.0"
      "sha256-FyldpLYeUMJe3YMXdhgffb8he0jkE2RQqNDZEbqSM5A=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.44.0"
      "sha256-T/ensozXBy0hvCA4Oxz5ZeGdrHb065wFzL0waYBy/6s=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.44.0"
      "sha256-44Ix439NagdB/Ui2MnK0S6bQKe1sswoOmeIcGETjF/o=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.44.0"
      "sha256-hEmy/yeG2cT16cdRgPwhu6s2GKDYChag3gmQPCmvgho=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.44.0"
      "sha256-eRDFA25BJOZh6miBA1shRQmYAXivq4WT34m3AVDcvjI=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.44.0"
      "sha256-C1uu84RHei6dBJVrpwd2njG6Bj69BKOUtRLj2EocuXc=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.44.0"
      "sha256-nrze0BX1PnNV5O4+RhG6Dt1xfpUj0mGO/+lX2u+Hvh8=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.44.0"
      "sha256-ny806RuP4di2MHVtJLUXnuLi804iRYzqFf4N0RjqKPM=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.44.0"
      "sha256-ptCCuAhNA7Wlw2yYqKHU3w8YwgGpl204dWllHSBMQR4=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.44.0"
      "sha256-aQhTdAcGRSH/h0PxSXrZov015MiYS7RrFHn+yfeiWOs=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.44.0"
      "sha256-Kki3EhUWb/k7TgciMzVC4i56srCL51GFV9BlRhVewLY=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.44.0"
      "sha256-XY/OHJKZZvODm8M2TbXAtBQzMase0QORFSmndUVXP9A=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.44.0"
      "sha256-grSmFdAOEod9lLhFAZ0df1nh0VgLpH6FXk8kRTfS/dU=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.44.0"
      "sha256-idl8Flv9iuINTZxjNp4EVz8XDC9+L0p+13Ydz3Y1hho=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.44.0"
      "sha256-HQt4mX6hq1EyURDVfQpJGiJDP2I5QX+GKgjhvmwJcxE=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.44.0"
      "sha256-MOs+/ftQWeAMrBE7NESFGcIcJYCRU/wIE2Dlmg0JFos=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.44.0"
      "sha256-r0bGqPNHTuDUOPXGRpOCmNTnWwK4C1o0nyZEtPnMPTM=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.44.0"
      "sha256-nvEcTYzI6seVmTfUEwftmeDR2Dd3EdFSc1/A2Wp9AjM=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.44.0"
      "sha256-FOZY/LLTnDgQC+BukapV5adK25vfgzTRlbGJJVNMTYs=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.44.0"
      "sha256-r8x9JJGlpwt4XsxnuKQjeGRYzSPLgvwYKEo4ssqQz9o=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.44.0"
      "sha256-ncZ7f1d0ZqqhUfHuOf+B/TkWJ4qKnaI3jcMup0fS7tY=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.44.0"
      "sha256-sxA5hor4KNpFidS/POwwYnN+gC4XdKTCS6DkpPicatg=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.44.0"
      "sha256-ISN4VGZVpUoa3BHSha79iqzSN/W4Vo560nAXLX3+R+8=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.44.0"
      "sha256-oM97nm311j/8+XkQy0Vz6Lg7gZRo2TkuKOxtHIv70R4=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.44.0"
      "sha256-AJqAYFWEDK4sI0seK+uF1mpDfuyqOt91iV9sonDbmlM=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.44.0"
      "sha256-IM69ukduQBTNHmfgPE2PpBaM/g6dnkF/Nc97nSYocpA=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.44.0"
      "sha256-+Mlii1B/IoiWzMSv/mh7J9qnhb5dZq9Zwefc5L1sre0=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.44.0"
      "sha256-hHOr/qev8s6sMRaeXciqRWtDuqi1M7IuWL8jAeK7BmM=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.44.0"
      "sha256-7uvfcjiSMYsigcBJ3lK6PdKSDOT17iJ8W3JKdOKr96Y=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.44.0"
      "sha256-1RNAeYb7FCFWUvoqEFtvUISy82n8WlR0jbINBmfpoyY=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.44.0"
      "sha256-P/06IwXkWrq804B3JF1iTrMycz69oh7nI9D6JYuVV3g=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.44.0"
      "sha256-yVV+4tgo+Ze680SYvbx0HYCifqObesAU0qPAE2tnBS4=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.44.0"
      "sha256-VNe142gcoSRXelM5aEtx0dmZNUErDS+P0Wx3i8ZdpdI=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.44.0"
      "sha256-DJqr/sR5I1GxV53V5F3bckrU3e/D53TVs9wU2sIOHPg=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.44.0"
      "sha256-8VguNmIjvDnA8yV3yscNCI41eLPsiFqqB7AAICv8rGc=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.44.0"
      "sha256-ECSJRV9el/QBa+8GawehiyIiBU0AUUDD4Akuf3fytRQ=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.44.0"
      "sha256-z3nETGSfwCS1QfzcQ2UHGSgW44rID2/Vvz1PPQpwYIo=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.44.0"
      "sha256-rVA1GaK4UtJ61s8uHlnVAXv3SehkFHqJOBHA0CC/VXY=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.44.0"
      "sha256-Du84JaqpcEGPFMRrXZnsrtn4GJKyu4Ct4s4jiLYyXTI=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.44.0"
      "sha256-rf4lTPUsFw2s3AnTte1vdEma/nHQPNU0PL0aRO/u8Gw=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.44.0"
      "sha256-pc0MAl9bfGPloIt28PuRjgNsPwIOy5fDYnFBOJ+yQrM=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.44.0"
      "sha256-GSGfbFRXSOk80EN7nw3MK3wgZDboJdvZBqjgYDrzHVg=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.44.0"
      "sha256-tpBcm33XysDigsqEOphEtXQk7MEqBZnjWlZP8KiwBz8=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.44.0"
      "sha256-0r8zrTDROfRY3KRCKHSmdDed+QC/eaHM9cGs28dctrs=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.44.0"
      "sha256-9vJaTcwk6tugP5nXWLTYAVqeHcXO468HusAaHhYd2+I=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.44.0"
      "sha256-ipAH2qdUo0HRRRLRu/4cnmCW5P7KccQECVsdcRPhrO0=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.44.0"
      "sha256-7fTiBDQhVg3bafWhrSUceL3wqKPyY9knBUBTLvHp3KU=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.44.0"
      "sha256-NWQTQY7M1kKGjbLex3VlWbcVbWTDib8NCRcYp12RX2M=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.44.0"
      "sha256-kPix+/ETswGJ3sttcj0v7N65QuFjRLFRweO8w7s7+Wk=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.44.0"
      "sha256-bDkAtSXDQQU+Ch0v/kwEPsQuijGKXDqE2QellrhSHPM=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.44.0"
      "sha256-vJnqO27umRyvkQZd68XUppIpic8OSPDyKgT6XetMzKQ=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.44.0"
      "sha256-oMkYi9sdfVRKku+v9dLckwviD7yHl8Pg6oAL1Z9QZnM=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.44.0"
      "sha256-6PW4oJuDVRoEOj7AzukWCmsOevKlT4wwnCdBdluwE24=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.44.0"
      "sha256-76rpNA87G945z/KOnKpQ99KWgKNS6sp53wIh4rn6DCA=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.44.0"
      "sha256-L0BCYp6uPd5u91DQzyPUY8wlTCT/OPvjk14/h24yfNc=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.44.0"
      "sha256-bSi5O0X+E8QhoKlKkT4CMOlmcc/SGlzxFxSwgmf4Raw=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.44.0"
      "sha256-wMwOGcnBbmwl6EGCzby/VjNvhEfvhymWRBPZupoIyoE=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.44.0"
      "sha256-PgH6PmMLrYLMhEiYhvFJXwvc3rWuGGb6bZP7LshxP/Y=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.44.0"
      "sha256-L4ghjLUYPnNJTzrp1q0ABzOlpsdV/qv3qqF6RFCHAOU=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.44.0"
      "sha256-FDEjPH5F5uHLbEXYHd93tjJxI9IIARZgUPlL0gL/3gY=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.44.0"
      "sha256-PYiWW5GGTxoQDLTitRuhjKnjmf39sE0ZN0yMRXbCvNA=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.44.0"
      "sha256-zr47k2YV3WHv4LBF0OwQIIuHvg8PDyek3say/IElQ7w=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.44.0"
      "sha256-Yu4X4IMJylI7wfbbM7qf+fEqjASO4B7s4D2j8VQFtKk=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.44.0"
      "sha256-CHsIakj/plq1A2oxR0JivarVrBG9cZUiC7f2XYe8y9U=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.44.0"
      "sha256-BiEHs5iqoFooRFL+BqxTRDrBQgzWzzaMfMBlU+QqBN4=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.44.0"
      "sha256-h5k/Omrf7iAoXWP0Rs84nkIbb7Qhj3cgNjQC+3uwnCE=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.44.0"
      "sha256-u6i3fJH4Yrq184pZaSu0yTmMoX/M1klPvAcU0JKalFQ=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.44.0"
      "sha256-2P9ZsVJFrQpzvA1sgXrN9BGsxlZhJX/ipvRqfg2zdXI=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.44.0"
      "sha256-b+SPfOsgHCAF69YkfHDlAsWy40kDjVk8HRfEwz4Gjj0=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.44.0"
      "sha256-f/jga3Z/pWLdYEgmLgcxZBRJ6bOSCqvpH/nm/xw2d24=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.44.0"
      "sha256-CnZV3A9UbznjvjtYIqBaES/vjeALzH+I20ul0018NqA=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.44.0"
      "sha256-PGVZDTpXHWzJJRQRynT8yW6YtUIXVpl01P+CFcTilNA=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.44.0"
      "sha256-mNNRwU0ZskX+ug+4ng5vgUbYpbMJCQ6vkrqByFhhX1I=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.44.0"
      "sha256-P9YZj6nraYkZwctmazqfMU0rbyJYw5IahKK+89R/Ldk=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.44.0"
      "sha256-ty08zCwP+Qql7xB+zaqJZksTPjDS5aFbtYod+tNpNr4=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.44.0"
      "sha256-8bU5bePN3fhzl37c+bCBBST10W5YVatCle+ckcXV74I=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.44.0"
      "sha256-R9TOCFcoJRDJKScT3MtdjJMWcSVCS2ZH58+mtF3w/V4=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.44.0"
      "sha256-eC0hbSSUD70LUsUPkTuVdxD7m5dYFfcNVC59sFk5rsg=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.44.0"
      "sha256-/XTJ0lJF5V08OG7Dn3tBMy5sYXRUf7pCiHKtpTFXPg4=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.44.0"
      "sha256-HjhqkX3noqy4XsquHNM3pRqx+fd7LjlDfEdSB2j1vjo=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.44.0"
      "sha256-tuQ3vJWTIELuNYlYeyGzWrcXJI/JUzjCCYzBfV/rVZ8=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.44.0"
      "sha256-zum8BQIQMFbSxnIjZr6OBJy8piuQg/55Tha1ICxprr4=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.44.0"
      "sha256-DcTzblXxztH32zFwlC4CAvvW+3MohILHqsQvKOq448k=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.44.0"
      "sha256-m6Z58bJcwOXLsMLJbJABX6ji3tMbQ9Z4WD1yp/tpCT8=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.44.0"
      "sha256-fPNvA9k1Zx3sxRN3ETfrsOophp4JBYo3IOp9f3hrieQ=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.42.3"
      "sha256-6fH7Mf2p9tYmendYBCHXKo+6NKkRP2j2ofLTrkxlrtU=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.44.0"
      "sha256-8RIRHfVRtNpwN4FGXFPZ1eVgBIAHsRdEpSoxhHa1kWQ=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.44.0"
      "sha256-DMqMxg82PMIuyumvdroD1y4Mt1lDX//+A8IEGdIDAy0=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.44.0"
      "sha256-ac1scacBklkpXE7Cs8dckA6cY1G8WFg2ZfvCdfjjh2M=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.44.0"
      "sha256-N+44oox12McBmcuW+Lj0aJxOKajC3dyGpbg/JTRi+IA=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.44.0"
      "sha256-m0NU266WBIzHnG6A+C8Uh6ch82o2C6MXuABTzs3/0Bs=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.44.0"
      "sha256-q3GVLGdqADJYU+AnzerX2JFrILqe4uTlxBMubr7OJ9M=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.44.0"
      "sha256-F8Y5qtAVUw9va8MH7B/+r9lS5uxxA5cuzPJBj2iTsLo=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.44.0"
      "sha256-nugl94CG6zVWyZ/wQVzlv3oj5ARjq7gCvyEhEnSnON4=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.42.35"
      "sha256-kdSGsikyLazIdSKidTt6bk5i+syJgx/GE0y+KRpC1rw=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.43.0"
      "sha256-CjVX0pF3be2BNpJy/+zWJ7/YZSszPlLWgIL/Qo7jKoY=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.43.0"
      "sha256-bPKKphp64m4s7ceo0ypSfyqY/AGzqFkIWQksqDIRLSM=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.44.0"
      "sha256-lrvrYopThGYoQ2sHv99ZmfyLbVpcxpcnA5ZqyVyP70M=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.44.0"
      "sha256-6vRlZkMB25BqngXqmYzhMUE9a7iX9SpxNv5deb1fZUo=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.44.0"
      "sha256-Lc421qeNx7oncCZ1rauYsOwqnHVLfooNdzu3hZm3xuI=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.44.0"
      "sha256-qnBIjfKjwKIJuZq9RlEK2BA1iDtHyMSIwklsxIHIDlo=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.44.0"
      "sha256-jeJqwOiO3N3+0l89gwLY9gMN5MjS8oTv96y0FSgJddc=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.44.0"
      "sha256-V70JqgPlOtU+lsR89qwV9RIeUXDFTz+mGaF0ojGCrHQ=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.44.0"
      "sha256-m3bBAofXhyte1JvntpYk5WreusaMLtYfvvN/ARXE3sM=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.44.0"
      "sha256-NJZKouvHCPF5weMysc3MQJ4uiY8265p/oUZpT9PvEGE=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.44.0"
      "sha256-8YNelgWU/dkdSDQDKO/XfruiC2zFlb4CZjcfn/SFk7c=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.44.0"
      "sha256-UCaI9cKccZukd4zSGKqt2/RVVgnyPjKRDtDY1SmXZO0=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.44.0"
      "sha256-1HldhpB+mSlE0TehvKlgsMxT6lUKRgGdrGu9t2tDuZc=";
  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.44.0"
      "sha256-Y7izWDvHFjzd1FaqzVaTohgDffB62ct1inGEJKQobhc=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.44.0"
      "sha256-JHPwrgS2BtTucVFihAYyCt4f8DMun+h2KYV9iL2A5zE=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.44.0"
      "sha256-l0ldyKL0+O+TJt+Zy6ya+YWkvqrEknp7+tXgCP8nqt8=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.44.0"
      "sha256-jrDKEzVbWw7yMV42xcFga9AiFvpFnGWSMWptsLUZUG8=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.44.0"
      "sha256-dalgFZg9c4SVcb0EvbWlginW1CaMWWLGqDYB2EGWKjk=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.44.0"
      "sha256-eP26V8LzUx73lrSZC34hHhxgU2qOu4ERWUEIO//qhXw=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.44.0"
      "sha256-3ebU3awqDP7MC30zPAQrzf1nR6IK80K+b1kUum6HcG0=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.44.0"
      "sha256-8FVu+vuW5BBzuiiNNpFtqjWO+PB6hR70bj7ShtszWs4=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.44.0"
      "sha256-7khu80CII0L1pDyKO3HYLHiWxONNU8EKNIaH8Lj7KUE=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.44.0"
      "sha256-4gs5fy/X2T62xwe5XOi5n8WKTC3j0KnY/GJMDuuoz00=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.44.0"
      "sha256-jFU3LB2Fcc0KY4duOc+8hDTHYOtSYz+x2Pnaef9Unf0=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.44.0"
      "sha256-vb/GJXHTedWJecZWILJzAObi5GCpLRnSuu0MmQcx51o=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.44.0"
      "sha256-LKf5+ZKnDKrCvQf/2x4y8BlOdB4EN364yTcLQCAyH5A=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.44.0"
      "sha256-dZdl4fR5wOAfsF66ckTid2OAYci9PtgLIhVwUKESK14=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.44.0"
      "sha256-aYobupi/fVHCqe40ukUzjTcut92Bp0L+FpmUEQvfBgo=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.44.0"
      "sha256-CcEjMJaou/oeTt7CyLb4FlwJP+qfpd1NLO1Vt/ahXvo=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.44.0"
      "sha256-vj5zonRPguSbUI3oVcdqM53CyePVNGpT4KHi1p1cBJ0=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.42.3"
      "sha256-KnsQjmsXPq1VOsgdfPQ8NpXbXJ3ed3nQ6u4xd5SvGHI=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.44.0"
      "sha256-2vGcGCVVu8lDy0aTF2UPiv4DDOw6WyvWjha/evNFQ5M=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.43.0"
      "sha256-vrbVRBb2BCGTG+0hth2BQVmF62R/ufvrXHYfl2L9R/w=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.43.0"
      "sha256-UMcPVbdXrdQ0MApotjGVJTMhJABvM5sOU9liZSZJWBs=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.40.17"
      "sha256-SeJi6Z/TJAiqL6+21CMP6iZF/Skv1hnmldPrJpOHUfo=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.44.0"
      "sha256-PAuElrrnr4Lw/lP4BPwbHlEbJ2vbiys82wpzo/FskSU=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.44.0"
      "sha256-uK54/ED/f+CGQkBSAlesSVsPHfKjTjmYtVSF1eEK4lU=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.44.0"
      "sha256-RGuzTArAl0bILr5L8Szwt38Co9FPVl7z4cXiCIbXPrU=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.44.0"
      "sha256-qk7Okb8ENeJwDAqg3aFoS8RrI8UNPmcqYAxhHZnxO00=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.44.0"
      "sha256-7THMoXcSdmoCWLW1cVCBCi59k/la8NhsCTvCpaPDaPM=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.44.0"
      "sha256-5z0GWM0k3bBKTag312rNkOp1rbfsRV/Ss4C9pC9sRMA=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.44.0"
      "sha256-QCz9pT5pRK/+J01m6z+1vIyOe/zpM4Ud9gxIjjkE6Ys=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.44.0"
      "sha256-yfd/Mmp1bfz4jkKkPinEYdYb+04yYdpOWyJhC6uIgFA=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.44.0"
      "sha256-6ag+JfOaAgM3vDbulu/Hi/znT66v5wZUzdO6BP7Up6U=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.44.0"
      "sha256-ZxYHL5Icvpm3AjT6MjYeI26Dg2p9rj8z1u/Nd1Vw2i8=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.44.0"
      "sha256-q+Tnmh/V17hFstRU4hdifr+C7uklapCndCqkJhFiBOQ=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.44.0"
      "sha256-N8hZHgnn/dzQECcZpMiX/LvSKHo5XA6k8Yh/dwDiAtY=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.44.0"
      "sha256-TmOFmaP2IL92P+YDcxOErHWYQ3kmoDM8Wsi/iqQP4z4=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.44.0"
      "sha256-ELKk5u6tkz7+/e3/0JvTxEEMKNMXuKGXe7CS60K4AO0=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.44.0"
      "sha256-rFSSZ/f3QVVm3IiOEDi/lyRH1Q519BGWZyayX6Dc2OM=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.44.0"
      "sha256-piypzNdjJrLVU6vc5TvaDuIEPCFHUxjhppvbrA7ZP/8=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.44.0"
      "sha256-AR5sGrTkoe/dj5ImQVDwtRIy05R+J9oeeUij2DPeN8c=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.44.0"
      "sha256-SOP52gZ+NFqQ6f7ONcUDcrtPS4IxN2V6v4mn7n4a2EA=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.44.0"
      "sha256-rzGwp49Q+H1KU7AW2LYYx1vNq0CGwwDhRUNh1H6KvLY=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.44.0"
      "sha256-Na0HmksUOCYCQ/IKmJuaRLUbNbvvTNec4LF4jQZUYhE=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.44.0"
      "sha256-MIX2K+o0GP+EtKGugMvl6z/sXjZTb8IVkxQCc3b0hnU=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.44.0"
      "sha256-eg+EoS4hWXHjCr0hgd4vIUeeITFhdY2y+d3DuqBvkKk=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.44.0"
      "sha256-TjEEHeXyYR11jZFvvhYNGFmsop1bXJZP4SNuQyEx1cY=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.44.0"
      "sha256-kE1xY1aY4Z1DKIV6qflz1Jl+P0oDSQTJReIKzq/+fus=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.44.0"
      "sha256-XvOvOQSW/3E5hRSt2wsdbDv+o3rkXIiE/KozOoVcdAk=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.44.0"
      "sha256-xg8W8eojoZAbMoiaC3dAacvUbreqbl9dOoJMv55LN3o=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.44.0"
      "sha256-MbMYBMhVkglu9zfZuyqsSYlUtlRs7OtGFrAACNKTg6M=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.44.0"
      "sha256-2PsxXVC59jvzMv4QZpc71ma56hmNO6OKfca+fbRCtvw=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.44.0"
      "sha256-cW6O7syuE5XqXQELXFeZrTA+onZE5HryYCPEHDGs6QE=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.44.0"
      "sha256-U15sCTUTJLenr4oj6xmFlR2eXd/JtdfamtxPyaXexFc=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.44.0"
      "sha256-2+bZjjiR6mRUVaXAFWiD2axmdfvccqwwwjX5gOhMe14=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.44.0"
      "sha256-I7d4pAN6Ce7w/+F2l7QiD6CXHJOv/HsasbqkoRXDIag=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.44.0"
      "sha256-eVFauEEWMPDC9ufdBW4GqLF/wsMxMkPGhaw+wgmRI/g=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.44.0"
      "sha256-fmZ96jqRxyfNocXEqhgKW3yMsdRTPtfDFvvP9c87Fqw=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.44.0"
      "sha256-5xN+YHkIhPyGZb/8s3AiowUeCKArkOoXx4ay0l+8rPM=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.44.0"
      "sha256-n+0NkWIZZEajJi5JfNQpkfQrhNClQNeL6jh2+r6c+lc=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.40.15"
      "sha256-ZcL1sZGlckqZFhCqTZwMeghP8K9Hee1Zi3N6wZb9hts=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.40.59"
      "sha256-MlMkIgzc2D3i5xAPdk+th0e9AYrvRxGwzl4zwEwy4xw=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.44.0"
      "sha256-D3sjaacPqIIcsch3C3m5qq0l3ebjDTPM/8AHtHDfNJA=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.44.0"
      "sha256-vgNABa72k+btSsXHW7gHPkIBTI2O4QHQfhK/VkQDxa8=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.44.0"
      "sha256-J2p2uFzOJXZuuZaKNMWzYW/zdx/VvxQj81cUxS1wTPU=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.44.0"
      "sha256-cMZuBKgQnenLH37cePepmUz0ro+HVFKhBzyP8+pZaE8=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.44.0"
      "sha256-3JN60coiVuF9QxziPv4QpSGpPCvZywiP6TnL1ent6BI=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.44.0"
      "sha256-NmSJDiccNcTY1OXin9aoDVa8eOTi9u8ix9njQ84gP2U=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.43.0"
      "sha256-j8CGEyfiQPa5ZvIoZdyzGrLnxbb93+uXrufCdkmiI2Q=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.43.0"
      "sha256-Ob9sh8Ng8I3sWiy/qwu+lfSvf+W2KQiprWX6QCNiSLM=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.43.119"
      "sha256-Rq32T+ouVmSaImB54b14OS4oQ9phagWV5Db++qWQwB8=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.43.126"
      "sha256-T+r9aw3nnlHJFkeb3kTARzDvi3ROLFtAgeMTsnN6cW8=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.43.121"
      "sha256-UdycP3NtFWedh/R771SmoSFDVMWd1iuOTuaiBDoISWs=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.43.0"
      "sha256-OPbU92VvD3YPihFUl00xa4PWvIXUy49CqPFGGZXxAt4=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.43.0"
      "sha256-5AqWiNGz9jemWb8dZkuGQXxPXIruMdDWcoRzbT+ZGro=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.43.108"
      "sha256-Hb05g605ESaacKl15tTze8j8r9pDgMu5+e5xI7/qLHI=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.43.0"
      "sha256-tT1iRnm3gOaY8clsRshI9NL1FF4aHlBhWyJMi/7HpE8=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.43.0"
      "sha256-8K0Xm6PMo+daS6xt4kBqaVvO2/LruFV7PVvugI7sNDU=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.43.111"
      "sha256-lxfXE40oiVrO9WT0nCV6/4LmZb+2Co8FOB9aY8T9K0g=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.43.4"
      "sha256-I+MxmW/fbfF3uX+EF2P+w6y62gndgoahOjfSm/KoX5g=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.43.0"
      "sha256-13fAVct/Icy2iWt9z+fFyHLbp+7X6kZjLCtiiqC8Emc=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.43.114"
      "sha256-MRxoDGfMSRz+NyIk4GYfHefo1vR9Jd54hFuTXykDun8=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.43.0"
      "sha256-V6xgiUn87wqIlWJGOpc7Zu24EDzROAspAn3qkRifsFU=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.43.124"
      "sha256-eXfCClOL+oYLnJqYjnZXbs+uqgz6PCH/jLQEZ/fEs/Q=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.43.0"
      "sha256-PIgHi6/xkiAjzrvgRgh6b2dLPTGoVnvd3xVLAW6nTCc=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.43.0"
      "sha256-InMFJXbw+lFAqmmjeCs8v1ICBrvnIJb/0xKRla/FVPc=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.43.0"
      "sha256-Qzuv+hkKiTS26EfgCkzV9FSgL1LCYhsT5nx1xdAQG64=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.43.0"
      "sha256-Xn8quvaU8HAJKLiUuh7vGqy6j/VYWrrdwAEuMnFSdzw=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.43.48"
      "sha256-ALT7Le8lS4EXFe1a92z0t0iT8aYKOxJS5EGic/7hwC8=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.43.0"
      "sha256-Igsngmg9PeJcyqX/Ih+fgzUuBotaf+2UWHK9RKEePL4=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.43.87"
      "sha256-ZhOFMEuW4wICCHkvbcc4r0EC1LT7yjvPXAqRF1ytzs4=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.43.28"
      "sha256-igWmbkUqAiS+kCoH5DV72SaVD1eaX+70V1HcYnTGXfw=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.43.121"
      "sha256-8SBHSeT7G+ClVImWjBMqy16cDOCY6N5FxXqCoUJTfwg=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.43.117"
      "sha256-+czw4HI+07Fet1W7I/L+Yy7fS08ckeFX3TYENOof3To=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.43.118"
      "sha256-rOg20QfQNRMAUCTO4tTJ1yNkg9XQA4pPuxa064KypXM=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.43.0"
      "sha256-BUl/wnJKR3TB1YsTCLrJdEoH9Lz8DZ6H94STOOX8gkQ=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.43.123"
      "sha256-suAzwQBnbqikSkuyEbdAOyfW4QE8f+2WiWC8/gsvVwg=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.43.127"
      "sha256-KA/j4euxpKqiT2GhO0H5egpYpU8rpXgm0sfw1J/IHAI=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.43.118"
      "sha256-cFog1qECcxbFCkLEsWm/Ka4LJqXuEDP0H0997sCzu+A=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.40.0"
      "sha256-ZuSVlDalSjVyMGVem02HklbAmDZXJeWnd2GBrMFJKHU=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.40.0"
      "sha256-JEuEjo0htTuDCZx2nNJK2Zq59oSUqkMf4BrNamerfVk=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.43.114"
      "sha256-hgbybiFil4KDESTTZkFn0wTjtlyowLJGPc3XS/kTfzI=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.43.0"
      "sha256-0rAEnU+3VsESGKlu8OTnY//rzwRqvROhRFga+vnwd1k=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.43.92"
      "sha256-Ng9IMvLhm5GzcRSeGJYE33JI0f64epq4zShixnC/hVQ=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.43.0"
      "sha256-DDNWvmo+i3O3s8sL16zg+QhWYzfrSTPOBHni8PVOgbs=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.43.24"
      "sha256-R+9NhCyUKOhMZCyWll1kilbBGlcNfpqEXgQVskDo/nU=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.43.101"
      "sha256-+ehZjwJnUSvVBuXJvzE//FV1ApUUjTndOsu8Sctr+dg=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.43.0"
      "sha256-vAaiVQlvQzF8Pmmletyj8eWJ0oWeh3BFsLz4yJDP1Hw=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.43.0"
      "sha256-YM3HbNdW4xYvsJaiQ0MxAOo7bTHXbB95jNwyUBqV488=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.43.0"
      "sha256-G4Yi1ZVrkTRZYIHoWGOITtn0aUTiInKICGYr+0Jdyw4=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.43.0"
      "sha256-jA+JYi8QNlcBHN594d4Iur14ytDdg7/G3pXIWdvY2Yo=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.43.110"
      "sha256-mPbJdqMov2OuBAqtVsBL2V/lCYMAA5u7xsC8jYkCOVM=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.43.0"
      "sha256-nMG7mVx53CqENoZ2AJnvMbzn+ZIK/Tf1eeBc8PsJ50c=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.43.0"
      "sha256-KPqjClzMa/GzS/PHI5l/TVCbTmZltTAS21kr1BTAR1g=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.43.0"
      "sha256-A8/WYxFn06rUXtcIHsKfs7HxvOBges0wDGskm31NIyw=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.43.112"
      "sha256-gEedyGXQuVE/UPuVWB7AobxWl1OpDLHfXtVUO1JLfLA=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.43.0"
      "sha256-5bmcUB1MIxJ34XQSsE41OrGfhy8c614AZenIWM885v8=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.43.124"
      "sha256-I6qmV3fgbbyzsXbSJpW3nQQ+705tlWTvkCa36EnVsJE=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.43.0"
      "sha256-bj4/jUE8pkOLIiC1um5TU0AVhc877vWZndeixsxMthc=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.43.0"
      "sha256-zWR60l2zlboeCCP7n9wrx6j4R6/jfnrBkWaT0u669pc=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.40.54"
      "sha256-7h7WswVMGPBf6WsX04+TXA3o8scarCUqnSW3dgUyadw=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.40.54"
      "sha256-YrrEKl3aGz//5Z5JGapHhWtk6hBXQ4cuRQmLqGYztzg=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.43.125"
      "sha256-03OeUgYW+uyCFb8Oj9AVp5adQapyL1hnBSRpLaTx9p0=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.43.126"
      "sha256-N/tHaOJ7KODyCi2ApQwVQrF9NyJEnnlNAxgkBNwuSb4=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.43.0"
      "sha256-ZmYC3YQujmfSUK0pOGCGFwT7LrSa3oJfo9juUb+2Xpk=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.43.124"
      "sha256-mdtGs8qkT4GAT9oKbATHkspWbIoYPx40U+ENUmja32w=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.43.37"
      "sha256-11kfuBIlPjrL6NdBeo+23xYQfL9eeu+C7Gfi2aorNDI=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.43.75"
      "sha256-5qI1H2mPuyqoz1KmntNcGz/NYxJnq4Cj4m7CZrzo7qU=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.43.117"
      "sha256-qpypbW9MVy5XxBdIsRSRd4g8OoG5IjRt99KFEUuPnfI=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.43.75"
      "sha256-qPiRg1TifdbOHPT1gOUJhvfMm/4/LMwiLAU/3FWrE/0=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.43.103"
      "sha256-PWX/QMTPoUfANbQYx8QeQSnpeQ/pGyJx9WV8fYehACA=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.43.0"
      "sha256-q1NTyAk8F3hQBeh23YBA/416Xr9Di0xGfGm9fqzmMTU=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.43.37"
      "sha256-hY4oe6Uxfs4ZIUEGLddEVh5WPjmHmkk3O5qpAObR3e4=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.43.0"
      "sha256-cI7cDSHrRZj3RTYVHJ/6lYqz6qgYUPIlc4VUeSW7xIY=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.43.15"
      "sha256-8WMmFh5E1wdCmf9CIZscwj724oMIa3BNR+hwWHnC6TM=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.40.59"
      "sha256-jYAsZ1lMU9cl4rIvRO1UZLn4nIsuauWrNRwyB0j4HK0=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.43.124"
      "sha256-jpwazUBq9BL0rJiGMgwAU3ohpxylMSiSpPselO8y/zs=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.43.0"
      "sha256-Lva6G5n+26LxafVZ2wcZLgZYiYYnYwVM1E/jJkEiAUU=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.43.0"
      "sha256-LRvMiVOd/1BFnQhN+NR573WjuALNpCM4/DK7NC1h5GM=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.43.0"
      "sha256-upsBu22q1OGGkWaKk7nd+csGSyJoNdp8JZvSHHOU/U0=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.43.0"
      "sha256-4DYUxjIUCC/NHV5BRkeUNXC8wVF1rUJCDO3VWxubtjk=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.43.125"
      "sha256-ZlLzO+88EwD98G26LQbxrU9zda3pII5P8rPHJPpRwTg=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.43.102"
      "sha256-3zZAlrlpj/UBuZHwKsMAieZrB914C7Hk0kkLGpfEfYE=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.43.0"
      "sha256-8or7NMBfeq9jZRzAu0Q1ShoTXTm8GCXR4kov0kaJCcE=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.43.106"
      "sha256-cxGV8VgwaZo24p08irspGLzNNYfrLtyyM/gEaWeJMnk=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.43.127"
      "sha256-boGYqhn8XzNaFTkCf5UWHJb0bMRtmL6agH1OQW8D124=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.43.0"
      "sha256-T+JIJpHxD7IzAwq8yxgq6zbVMj/btpbhKnylMyfFvvU=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.43.127"
      "sha256-gm7Er/TZt7xPoCiBNneDhe8ydLLCAAoQd6xw25jlfyo=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.43.0"
      "sha256-jnUH8nHt54uG7FBxZx49prqx1Cc8DzNDgwNiL1QHeIA=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.43.0"
      "sha256-wwBlAR8kwqMGpHHMmXTUD1jW8YvtMl4lRR9KTV6RxME=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.43.87"
      "sha256-XkRHzmjBHdNHQwwOS62vbJPTg2kKFuokOvXO+qUsxvA=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.43.0"
      "sha256-qU03CsCdINIbkUWWZyJbWe0lcuw/xt/7P/ahMhB6afw=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.43.0"
      "sha256-OxrliFuV8nojK9YroUDbJAUt1eECaLeW/Nnww0+iU5g=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.43.68"
      "sha256-aMnsrMCq0pwyRsPAzuvGVCdDFYNooHv334jmMcI5Mz0=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.43.0"
      "sha256-UdTdVjxyxI4cZR13CjCtP+mj9EvH+pwB8lAYfNPWFXc=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.43.0"
      "sha256-4i9uiELT5+lZ6QJKsggSda/gxpKOkuwiT7xI4URdL68=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.43.0"
      "sha256-xg8JYWDWm6+Xr0juzrrfkh7rmQDGuU7Rtdd0z55I1cg=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.43.0"
      "sha256-CW9tYiy+Um/VTlnt0GhJvo/BSPnJJ5ILEPwMAhraHvY=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.43.0"
      "sha256-Jl7i/d+dPkKuOWhWJft4YaU5EQ2OMkNyhHwOHL1mayA=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.43.124"
      "sha256-9O039/VSjRJHlGlfGw+t/R3SUzRvbOyX9Rn5DJBTEmA=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.43.0"
      "sha256-pwyBQN0XXWN83ccE0gbCcJE8ozPn2pNMgj/nEOo/yq0=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.43.0"
      "sha256-UWNKYI0t5AzHph0jUQEc0R4NJT7izkr/pzO7k14LfDg=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.43.89"
      "sha256-VGIbYSvDorqsQfAZFpeRB4eDh3lyy1RjXMwQEv+ldg8=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.43.0"
      "sha256-J1UnC0SGqnPl1qjGh6gDaLBLa8OW2YMZtGJ27zQJcmM=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.43.0"
      "sha256-tX0woQcWoUOPKxSthE9p2rs1gsiA57DJY4JgreeAt0c=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.43.48"
      "sha256-F0UEyBR8QZyFfB5REL9P5z0zsZNhcddgxksj/tE+GXQ=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.43.0"
      "sha256-JO9Mm6dTJuFnbyRzuSaPpT2lvDNaSUMlspWgeH+bt5M=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.43.110"
      "sha256-cqxzurKfwbrVwYX99QXbbVpf1kudXhP1PkFFf0PYQP8=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.43.0"
      "sha256-Pd/d8Fxq1HQsGeiGP331Ss5RFNQA0W3HLU0B97llPZY=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.43.0"
      "sha256-O/moShH3i7avL5pzZ3NnmAwMAm0UUFp9g/TVTurpKzk=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.43.0"
      "sha256-Uh/EREUJuFFWw3ObXhDSWgU8DXRi2znVgfWhMhnhE0s=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.40.0"
      "sha256-ZVrH3luEpHwORa+1LNdmgju3+JUy9/F6ghNzHZUicBc=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.43.0"
      "sha256-fv7WLk2Kbrw8niNgGfqx88TZQVWbm9lUgyL2NCDitIE=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.43.0"
      "sha256-wXdXItgB+AgAXYF1KWJvn6XfFwdWXQR4RG6LknRlobM=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.43.97"
      "sha256-y9VnvgAgv3E+hVQuMHbdkgtNnVQt0sopLCN8PJTKulQ=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.43.0"
      "sha256-Psjh5lHoMK/89/4VGy4wkLjqmNc8sGkFOwnKTH9MhjY=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.43.126"
      "sha256-V7lfx4OTvMTuJmKBAenkkuCqXxdP4aRWM3K6jEa2mEw=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.43.0"
      "sha256-fwItFwvc3+G8xmDVqtSJqbEi6fey6JFFeNILLOsYOQA=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.43.0"
      "sha256-o2eCfk7QZjKSv8Bm8AmP3BL6M4QGVJrz8oMsmbF/yds=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.43.0"
      "sha256-Kd3EQQ6ZjEyBixSeXFSiPci9qyk/NuFP46O7jH8Esuc=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.43.0"
      "sha256-V1og1LY/ORrXbfFVs4vF8LYe30/kvG71F3rWwXmNSJ4=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.43.119"
      "sha256-8gW9SYhu8NehGKCkwC6RXcjPL5K21839RDmspZV5RwE=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.43.0"
      "sha256-rMrmybKplGKYPFr1cIQaHRs/bwcKFYlFWCQRe7PxXOk=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.43.117"
      "sha256-fa/CdgVHXGbbq1CM7l+EXP61MbvxQ8RMCL3fLFVyzWA=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.43.0"
      "sha256-Y3p6SUr/Ej8SiWm9Dk3ifaxF3vesKlCdglgIcoJDemk=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.43.94"
      "sha256-0WnjCd7s+Zy4qJfjRzNXH8qmBUR+Kbn2qMMiAsgmkM4=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.43.84"
      "sha256-idAR4rzgGjV373VLw6vB6GBK33GawNjNMVApo6YayUs=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.43.0"
      "sha256-/B05S4INFBRdthN3+ybnXQdzIWwldRKEdfdp4ngJKUs=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.43.0"
      "sha256-EGelGYE1b7seBg7WHOnY1Vumlw8iMqBAMIuUpPmIUIA=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.43.45"
      "sha256-WEz+PMPa1ojI7uyLyMq2s5P6u19uBI/8pra73oWsyKA=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.43.69"
      "sha256-RclJXtzfxHLiV/GLiIuPP553QGUC3BtI5EbiqChUbbs=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.43.0"
      "sha256-fCQPZ6Vb67Fc3l70/X2w0AhhUyz29PIBpTW49nfhwG8=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.43.0"
      "sha256-eYFkK6WzRSoUVnxhmQV6WGsnwS18+1oZOKPatxUPDBw=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.43.0"
      "sha256-fc0e8DEx/b6M3kPB4Y07qqqMayg2BGSQ69gkuhcrl9Y=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.43.98"
      "sha256-tiBz8d9cXwrI+7rsE+MnQzyt3BaXJ86Sd8ysVsRruwE=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.43.114"
      "sha256-3H/5m465bKEmoUgMx4acUql2dYi1W2Ws9dn7uZWie+4=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.43.110"
      "sha256-BJY7wvRhMKLlla9XCEkuyLbzOwBC1MyslbEX++XckIw=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.43.13"
      "sha256-TtndYsK7U4b9f1LWtXadwD3SyRPkx3uhjRIGYxybW1s=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.43.0"
      "sha256-OY+yyrxn5dKgzCjYvHp0oVlHY5i9zSO0nS7zyotc94o=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.43.97"
      "sha256-9iwn5kGGiBoxbeFCzFNBl3b1hPW87kul0ML1r1cm9NY=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.43.0"
      "sha256-sbQAgZlIVUy728L1TZOXvTzxmp4yvzswgMXJ5ieF3CE=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.43.0"
      "sha256-zwxwpve6uEpXNyMQzaFPIEqDI/JoP5ks2wmO5gqLf7c=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.43.125"
      "sha256-KIXspgIj6XozOPFY9JfymJQyORs1sgQ41yiYMmsVH5M=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.43.103"
      "sha256-URAjUItODqk4OPbhqlu1xnS8C6LF/PzQw8xdtHjHSg8=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.43.0"
      "sha256-Yyltlus+qxQqAzzi6P5yXElnn2tXaEUtB9lvobTGFBc=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.43.23"
      "sha256-muQgj+irB5ZQw+tIsWVUlUljC6uWT5D2BOXcXPf/Yeo=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.43.0"
      "sha256-AKgxPXa2diiYTDxZf6x+UAaDPtOK2RGTbG/p3falJ6M=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.43.0"
      "sha256-2glzIKBlui8YPvzI74bT4ADqEZ0lH9CuZqHtwz64Z3k=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.43.124"
      "sha256-hcicF0u/IUnXuSQHfEMbUBfMIHHI0h1odnTE08S0bks=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.43.0"
      "sha256-u4iLZ4mf7rRJvTpbroMyLfAQ8Y8StMpIVXFGkVvv3l0=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.43.115"
      "sha256-Kr74XaniaA8/DMOEXDxFIfY9vBFfeW3t0cPoh2tJVpI=";
}
