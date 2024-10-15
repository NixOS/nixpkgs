{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v9.0 (go-live)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-IcIfs7kmYWeUW0xI23FCgzzdTx/TstTzY/En7HZ3IYE="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-YtwuWl1DpYuKY97P2iJmm7ov5q05by3eFL4inl+Kwhc="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-aHywWxrhPfKRL5sZelbQiUZaMLRn+e4A3UXihjNBLoE="; })
    (fetchNupkg { pname = "Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-KaSR5WA+aTDOR41PuvwsXZt/zHsOJOKxBEfSGxFO07o="; })
    (fetchNupkg { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-f9o3PGHsW2BNMN9noBsUFv0SRRUR2m+RHceJtjCzd60="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-1P7Y8+FoxfaL3vTLPx5/LPYw2ZVhxC5sTSKbjHCPAuc="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-yT+zcwYGL1f8oMC7S9sdLjbLpaR5/zdrRtpozZ+w/YY="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-U8rxugP2w8JS1I1cTMzN3XYjw9uVHZqPDDppdE9dtns="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-iRO1a77VwLcu4vWro3eHHcxh8nQlY/ik4+pT/2c3khA="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-XIODRgELUOKfn5L5g40Mxzcf/qH7pCJoRRvZPW1eY38="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-hqYfNrj8fhgSMkK+sEQTtZdidJeD2vvvDoMBtK8ZmYI="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-JMpiQJY23noyNK0KjkkyGmYJJLyTNiHhlZPKA6vSQB4="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-XjcQWqUEadp9u90HZU45gt/ANzn7Z7yuV24SrMKY7tM="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-Dbt1T/Y9AsuITCNDu7+9to+9Q8aUAGmEsemONyucNkg="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-AlWrYGpqFSTj6UDEZ77kFq+KrN9SOO7fLu+R5hiICTM="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-ewDINCVRtePHQRceMn0xhUFNjEr08AsaS9WBvz3lcLs="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-8CNaSv1PxoyQGSc7W64BlviEgBtggYzSjDh6vPl3YSI="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-DV1kc2BhDSHgmWE7lqUtM3u5YfXl/EKo3FU04LHzP5o="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-58cO2fdzdLYkWC6q7dn5dXKpMj4WzE95tlnPqW0X+W0="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-GugOroZ0SRoGoP3xE3jt91vTbHwXLPq8bHYckNC8SIA="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-ceT9q9ZCwhGnp+BrxgjPcoyrAqKHc7VK47M4tM2pQmw="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-lvAHbw3hhS6OnCuUMLEa4NKJWZPHqcBM3IeXpeYtLHo="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-ZV5ptFKjt4UX+ytjnWMRk0/Xc+hR8tuYb8ADqLlTFnU="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-ULArvCiy+bOHtkD5E0q7u+Cfg7R+IJZ4A60ldV798vs="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-eC46DyuObx9VhFP4PyY/3JWqAck8bW4Bt2hZyuapLRY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-6WaE1hKyIBnsTe3YlVP/lHR9HOnMkYtqDZEZLzidFAc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-u7sukf/qUk+gUVxFj/r9rzkQTVUcg2SqNhOmhPOsEyg="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-pYPVNaL6x5zRCBxCsPso8Ae0k9aaDbvH0aHS+j5pdIs="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-hKCalXcwzlgMLwthSnTcHkDOW1g2XUo4Kj49uryZvt8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-qlxs6pqhMQHkvOkJY37f9VMlxwnjUffue656XJaRLWI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-h1FtdGrQp0HjK8fJajK1h5YV9fgBZCBQOH9M4pqMamE="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-EBCX8Uvy+Z40i+VjuUK+F5CAZYblQLKzAExfx/uQ+gE="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-KmyOl6C8u/PrCAMiY/KwELYvRafnM4SfcnEhKvU5BeU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-Q41rpitFgIbgUpIh7iGzXTaCVDoUoDJ7HYddW2krHAE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-bsQyjyidOkZLtjR1JadsIkRp6gDlHjEsJEbNLgKGtdE="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-2YfhVuvSJe2sIkPFgocqAJubbb1PU7r93YoICq3ntAo="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-oPUyQZ9bGNbk6yPeIAQkNmDmDNcq3o2jFIsunotBBps="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-CBwqR3ii9Yg3O9lG/UAFaltVHmH5aFk2r8+IV1zeIS4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-Uw965RIeMJJ3uV5xX6WWGVq8i+CHXpiOw1mOT6rPmFI="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-JBUxkn0eUboAElHl+o2LyC7f9eJz4jJ9/odxXa43FSM="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-ZsUpPpaD4cfjTnTPAw1VqKHYX51XFG1ck0Ae2dWUKt8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-RY5CrQ9K9VZeh8+1r8Rjg0gEFBBRqR5EGTFkBfx0+3Q="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-FG9CGm1wZlMzKGzr70+qg62NLmYot0uG9yilyoEBpmw="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-QtCqH/Ah7EW2lNWHq9y4sAQI+8XOWMLBrqPIuDEV1ic="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-wdwHZFStEDDU0v8nah6hylLErKUxC9x3CvgL/9Qcfwo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-QnGhafheornOKm2H+UO9M+a57S7OzU7oomMp1Gs+qcQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-v8J9etz1hP2q02KbUjKxDUc8So2qlzajFCDbM9N9TiE="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-HZS5qup9w2rWf1K5zIq7BEYTi8BC5co+Mz9Ey7iOcPc="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-hSj4rqdeeerbuFQT7DI38eIOI3XUUun7nfi4ypPyggU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-4sp79lNVzgWRV2l1WjURkZBTq13OTRPfoRsaWU1Kd+Q="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-JT2SL5C1RXS80C7hB+YcCHW9Nynq4+1dCd4nckZVDsM="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-pnE0Z0AxP+2tiQT72EIjrsfRxN9q/rWQ/5J1SIF8rVg="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-DO5bDJGbzav8ji/1Wp5+VCU2xd/7P+tD8eMCBCeisq0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-ORBkaFVuxvBBcqo0vklECC72Paoy13E33gt/ctHojq0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-oFvsMtKz+O9/B7asuc2DsH8KhRhAdS4D6qR64O8dE48="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-sXYAaSQvdrsknqu85ZzDfRFKQ3lKxPmK3CeYJwJ/u78="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-/GFhQQTpATa+eVsIKIS5hYQwEzueYT7IClqfTuO7OiY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-DJWq3FrbwU6QCJLuMWKFvQhwrszUHIHbZEi+cjnUkAI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-NtpJ9HN+LvXLb/qBn3Dz5XGTqhrlB8oUFCzge9zkxJ0="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-quzQ5GEyFmdsn7VXSsjSFHIcYnHwxb3OXP5Rcnar7mw="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-53HpBsY1A7xFKDSKW+yMjoTdK+calt2k8z1XQbIx39I="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-zzq0pwTb9ayiuFijGfhXPyIk7YsGu1Q611CvHhPAGPM="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-WUB7TDKuqe/+vZMdwtmb8yst0+6STi/H7gf1jmb0adw="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-mc6g5oRPUbsFFwn5KDeY0LbzLGlyiPZxAhtjGEsIh+I="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-rc.1.24452.1"; hash = "sha256-lMVZtEPD48KKReYFsJ2rmJzCvlQNkGvajbfmd/ZYfFA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-mHRvOES1i3VCmHfyQOakMNyvvJYS0xGdF8YFNpTEDx8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-X29sAPaFb6yZptgoQK6QnRKbLRmmkrnvWw2zHC1MHE8="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; hash = "sha256-8LP07HWuRAyUGk5aSIpBHcAso16yM6UQ7YbPAen0Zgs="; })
    ];
  };

in rec {
  release_9_0 = "9.0.0-rc.1";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-rc.1.24452.1";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c414fabc-f831-4c5d-af5e-8e85ebecc6a0/670acec9f83315bec2788393db85e708/aspnetcore-runtime-9.0.0-rc.1.24452.1-linux-arm.tar.gz";
        hash = "sha512-EgHd12xUpnbLKHRD7xszFtCHufNVfHl/ckzU/LhphutJmzEilZskl2RE4mIoXAWooPjz8oKJRjHlj6TeQrtUiQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c5075cd5-2552-4f77-96ce-31450f9ff8d5/e6ff2b52e2a27a60eb3585cbca01d60b/aspnetcore-runtime-9.0.0-rc.1.24452.1-linux-arm64.tar.gz";
        hash = "sha512-hGEKOPuamOt70muompxJmGguw//7Xq3lu6+6/WPKx9mlJ5YYu1slddJ/7sCY2l/m9xUMZyU/Pzd2JgFZA5bhIg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/da25731f-e296-4e2a-8f2b-0213d26e1799/859039cd012f8cfba53991f8f5543609/aspnetcore-runtime-9.0.0-rc.1.24452.1-linux-x64.tar.gz";
        hash = "sha512-+P0oXWe7BE1jFZaGnWMB4QoqJDyByaBQlqZq/0+zQxUpgSx0gubPDgZejgZfxQsWtQ1/KklaswB3povUWzujdg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8d4492ed-c733-4cfc-bf16-4f13191587f2/c843723067d5fc1d790ffa1810c683c1/aspnetcore-runtime-9.0.0-rc.1.24452.1-linux-musl-arm.tar.gz";
        hash = "sha512-Kdvu4spDebM0V+KwVliBFPoxgTUGxTWaIxRfI6QdBj0F6qCX6hF2I6QPqxE1FrRRUL0XovBXKHViwz/pFovymQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bc3735cb-fea1-4f97-8669-3ab0e389d055/084b94228b13a45478ac75f5158801b3/aspnetcore-runtime-9.0.0-rc.1.24452.1-linux-musl-arm64.tar.gz";
        hash = "sha512-n08aOk85N3d5v092zguXYxAtnKYX/99h/3Wg2Bxcxj+1BCcI/xCxqD5VgFDZuVu68Vn6d+J8wD4K00NEHhZLXg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/10aac5f7-c037-4874-8c05-425e668b0a24/4706d38e511259862e93a61f15dda28f/aspnetcore-runtime-9.0.0-rc.1.24452.1-linux-musl-x64.tar.gz";
        hash = "sha512-D5RfnHYZkY1hmmbPtsiwH9mTlDjOjvi+B5f66ky9c87eb9JcIlhV77eTvmcL/A9xmOnyMfoFEdfPMZ0vq7rJ0w==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0bae8dff-9440-4388-a03e-af44e20673a8/8ab257a4963967970cd59c31c213f38d/aspnetcore-runtime-9.0.0-rc.1.24452.1-osx-arm64.tar.gz";
        hash = "sha512-A/fgM1LRrS1U6d5MHN16lMIxG7NtTGKWZh+rKGzd6/P1cgT3OJLv1T9Dz7E7pzyvrpXQUixHvgMgPV+2mg7P6Q==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b0414fd7-20f9-4363-9dbf-072880e97b17/89584fa06e9ba1154a7e02402a28d82f/aspnetcore-runtime-9.0.0-rc.1.24452.1-osx-x64.tar.gz";
        hash = "sha512-/0puNbQfUgBSHqSyV7KT5NSPF4bMqpzYW1W6lq02A228FJ0v+CDx3/Xy2az2w4tsNUDnAMLC21/m2C1PhfRhrg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-rc.1.24431.7";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/26c238f2-53a2-4fdc-981e-31272c80d107/67c11b008d57d501cd2e5ca642cbc8c1/dotnet-runtime-9.0.0-rc.1.24431.7-linux-arm.tar.gz";
        hash = "sha512-ioPeMA6PnsZ/cFAE9VIpVz3Yv7EG9sQjie+ylsI4buJ4Rvgbqv5rQmnpxyaQN+XsPxN2xyvBA+RkHJGBp+V2Rw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/54f6fb3b-da5b-4a2d-98f4-ae07c814a586/e5f2a5ba551ffe53ea1c2ae9b7681f0b/dotnet-runtime-9.0.0-rc.1.24431.7-linux-arm64.tar.gz";
        hash = "sha512-hUK7k4Hk7Kbw687d7GhSXMWeNPckRhPPM8shUfVwwzRcttCBxJKwEHDnYtNEDwLUVYI0Uy1Y/z3JGQV+Bre9rA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/72048153-7c19-4e69-bcf3-22563060db07/cd181715a0f7cd3cec8c87b115181da9/dotnet-runtime-9.0.0-rc.1.24431.7-linux-x64.tar.gz";
        hash = "sha512-n5qFuNn2Ni7SwtDt79BJmRgbLDhmR2RPvB2fJIJVOHMkOZ7bHEC8f6jEetwi4tcdtfJc55RSHVnkbEBZO19sxQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c948e710-a590-4492-870d-1e44ce476a55/86522880c5160af3c81bfa71378b79b9/dotnet-runtime-9.0.0-rc.1.24431.7-linux-musl-arm.tar.gz";
        hash = "sha512-ERibzBMUhpSROsX7BQt324EErGLdOblwzZau85n3p87mVqMUtE8BE/lnJufuCiad6jhjcCD+BiYaiwHKDfnktA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9ef6c8f0-49ac-4b37-9e7a-0f2cbbc74472/ceebdb8281a18bc80d17147ec3146cd0/dotnet-runtime-9.0.0-rc.1.24431.7-linux-musl-arm64.tar.gz";
        hash = "sha512-3WKnNzaydaFbWv+jRloO89aWGaBsyqo5FrMx9Fs4WakCjnjrfNhcdm3v+5cDx7uWeI9AYdVJy98yW/gYlDEFIQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/30c11bec-b456-45de-bb45-5e892fd1a509/cd72910d2c8b0c908f717a3563c2445f/dotnet-runtime-9.0.0-rc.1.24431.7-linux-musl-x64.tar.gz";
        hash = "sha512-vXcBXKRriSj3CmHmz+8jxeMIrUDAPd1CHCEBQbGjjNXE2O31Nl6LruIn21pqxx++pIHBqLPFum6lgzCv3X/iMQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8abf3e03-1ab3-40fd-a9cf-fa22005be2e8/cb0c3c5d130ef8ae76a982860fd3606a/dotnet-runtime-9.0.0-rc.1.24431.7-osx-arm64.tar.gz";
        hash = "sha512-qCX8qe3eU6tqvA7+DETW+yXFx3rrLTW2xBTULzZEU86wae2duIZcK7glI5ifzrfMy/hgR2mVkP91amucVMIddA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/13d7d905-549f-44e8-9062-a678a742c5fb/94c51ca9c08ef9b5cceabafc2337118f/dotnet-runtime-9.0.0-rc.1.24431.7-osx-x64.tar.gz";
        hash = "sha512-9i+GfqtjNzfEUP+wVDpybxui9GpCZctHl42I2tDGuAqNtcz29YOEL4XLYTuW0vfGgG1mmCb0uSuQbnHY0Q5T6A==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-rc.1.24452.12";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/87c96627-cf20-47d7-8cb4-d5e083084dd4/07d4b533e746b344a3dbf9f7279f450b/dotnet-sdk-9.0.100-rc.1.24452.12-linux-arm.tar.gz";
        hash = "sha512-8xpKLDCAqSHP3XGTPR9XwvV/9MQ/WgrW9SZAvHkeVPjAUm2OEgatIfhoI1elPPbUiKiwEQfnw0vq/iyMNCXdjA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f7739964-9e84-4bb7-9435-509458a15f9c/a95ad7f9deb8ce2fd30173dfe86f55ba/dotnet-sdk-9.0.100-rc.1.24452.12-linux-arm64.tar.gz";
        hash = "sha512-9XQlNxKIAcGZoScmYXUGYFh4iibopgPL0mocFunvM6XUGOR5Cjzqci195IPu6LaODeS7Hf3yeXEzae07TRY6EQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3b2b3c23-574b-45d7-b2b0-c67f0e935308/23ed647eb71a8f07414124422c15927d/dotnet-sdk-9.0.100-rc.1.24452.12-linux-x64.tar.gz";
        hash = "sha512-6BMIF7d50BBKbu4z2Y2Xw/rRwzYBNDX0fA6eIjcBcrddo3reduSd7Hy+aWiEOQ0uaUHMaeK61Vk9bRxrQQgwUQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8cb683aa-4558-45ac-944a-73ac40b708d2/2795bd0253d5518490378edc7f7b562e/dotnet-sdk-9.0.100-rc.1.24452.12-linux-musl-arm.tar.gz";
        hash = "sha512-hICQDhS9EDT1hsPhdAK+LwTKslDXm00d2jqoh+n6+mg604it9/JbXHsNxDM3XOHCcrPZQZY25tsPe/MA6EGgpQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8737d284-0c4b-49a0-984c-23fddc7abcd8/ada586539e4417b557d60d0214e8b2eb/dotnet-sdk-9.0.100-rc.1.24452.12-linux-musl-arm64.tar.gz";
        hash = "sha512-ZWv6TnxKPuKAuZ6v+mILCbibOjufbTPJ14fB+JOLhK+1qkPYBUboGiv9UydwwoLFmuoWf1DQGlcCeiBh5ZXw6Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/791e9a41-59da-4f92-9dfb-2cceaaea001b/710f7adf35dc2f32be49ac2834ad0afd/dotnet-sdk-9.0.100-rc.1.24452.12-linux-musl-x64.tar.gz";
        hash = "sha512-sdgATPnD/7Uw+7PUJZF0ywdqMroAJo2qQ9v0Uv5tRsz5eaY9f1OucKL6ehAanfG9O4QFUqySqFIRm7c4WmX2Xw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/930f4eb8-188f-47d5-8a26-28ca393b7d1b/c07a519e3d7e326c3f640ef72ea1193e/dotnet-sdk-9.0.100-rc.1.24452.12-osx-arm64.tar.gz";
        hash = "sha512-rzCzHNk36fyX4WS4NijCwezSEym3X3Qtn1IyqmhCfSW11wLMVlqoYNPHOMhyd5BWm/ZqPtdOXO9xmuWJ0wKEbw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e26e36f6-746f-462c-8599-5d0a1f00e786/f1b8264ac10442b40009aa8cea46b23b/dotnet-sdk-9.0.100-rc.1.24452.12-osx-x64.tar.gz";
        hash = "sha512-DR8HGO7vAGw+z77+6/nfB3LsIsdNtLtjW2RjuK7f05VydLkItR7AGc7WnT569K6SUvGOh7FKRBHhCJpMxB430A==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
