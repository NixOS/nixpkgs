{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.3";
      hash = "sha512-vyYMaRMsoWiCXq7leJnK922oQE649XLPHB3xt+Sa1JjmeZX68fvDy8BW1ZyCMLEESy8ncC0SDBNEUIcnL8xIpg==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.3";
      hash = "sha512-egUcbQx7nmplsmjtA7VAvXS6r6dyoa3W83+dJvf0ZTd6N2i0TSnujbdmtubfSczR9x/vPlQ9gmLokuFkeSuehQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.3";
      hash = "sha512-3XAhdSwKb+6U5trjxmAVwrExDpD/asmKgM/cr2LB/KjQo0xkrFsyZK5lYT9rMcDUG7KO4Ffdb2xdJCguddBWHg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.3";
      hash = "sha512-Iamou+8WWbIIgm3Xukw8hupl749/hXXOUS5oF06srcdsYXYehzBsKFytpyhwxZUYO3y2gYb7a4f3PFsE35tzMA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.3";
      hash = "sha512-nJhEo+JPVp1lERWKvRX0CGy55mabXQhby3W7hdUJI1jiuw+D9vacS3MKYcQ+kHuI/UqgD8g4Tkh3iqAKmUk/eg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.3";
      hash = "sha512-Z/Csa63C1IrRV9JQ04BIKRZSuwdiqwmap2g39pBvXof/pbLcGHehxmvHJaM0UqOGXjZlo1NpEERqosgBN4b00Q==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.3";
        hash = "sha512-DZGd/kPOW1JRk9fI3/hJySPxkj62rNw11vm2G32dU/Vo+MmoVdPyfj5+FFeaS71W8GqcPOHZmmlmokk7WsT5tg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.3";
        hash = "sha512-hBBrk8jw8PN7OrW0HepDaPSVUiVLVKyw+QxffYNCMqPqQj9FTsxsIMqvZ3CXIH/T9YUzulSv/c4Fx4HDMReSPg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.3";
        hash = "sha512-+k58Zcu0Qhtjk+q5csN5OrG3S19vw+Zrwihmllh3p6ycoB8sb7GvUdzrKk1NEBqVX0cTsEZWjIxVA0IWiukE5Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.3";
        hash = "sha512-d01YWorxCwggkRjS7JEok834CPLOm9ZvEm8KSYPnxgsld/biOn73NrE3Adhad+IGPlB78TCtN86iBT97khJs0A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.3";
        hash = "sha512-T3vcenf4JXExXNpbB8iNGingxUS5E11bbaTT7eWby+Yq/6xWMB3adLiARfDk16BJm3svu4FKmJWdbGX8Crhz8w==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.3";
        hash = "sha512-DOLyzLePRdYmkK0EXtFGGKt1mihmP+upxv71/ccEQfQ1U8t7Lfz/IiI7bihhX44wBKkCfFWlNtWin+VW/AJcJQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.3";
        hash = "sha512-9yKaHfvCk4OJO0CTlp3L5OSMJizzmochhtfkFXwOqqO5e2fgUGi2nn6VJIXajDsgOrmVBF8XufFL1s/g6q9SQA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.3";
        hash = "sha512-OyQ/d4iN9K/mOVGvTyvJJ9bLEP/Mpgcu4p75HVrnAjl7M0/v80jh+uBM+8G6VWvEuYgWZqUrUPsn/Aw5oUxS+A==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.3";
        hash = "sha512-sMlCyEVbl63nuhJzjZ3jfZniVGI3HsfCVTzLYDCda5h28UNkqphuZMmlV1OV5ftOZ5Q7gMKCC+8byyZcIbod4Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.3";
        hash = "sha512-fSl11bWl5ZX3tc2YJWyelvqsuTQT7/Fu6gDVSmh+jxQyxsvoyLKOkcM7+bwKsrPalouhErdzmTQyRMXdX7w1iA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.3";
        hash = "sha512-wwo0BdlcwZpmSYFA7e5+QKeUoLCIDurAnMnD3ME8AIx4bx//Id/Ej6h/lqGcw3oIBvOxpB5xxbuoTFHhN5yKgg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.3";
        hash = "sha512-CIhbfQvk6ciFxCe+LFMeZ754jwaCaFyy8bX02Y0lSYNq6BS5+wKDnpp1U3W2ZKtH/9R2YJeYxcUEGY8p/YwG6w==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.3";
        hash = "sha512-3SYuAGo7FZ648DK5xk4kZ22RISXhF2zzgIxZ7la9qUoOU3WylQg/uG4Ebi3h4E6iKFdTETQGu2+RV7CKgqcBCw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.3";
        hash = "sha512-38fBzgDCDVXEEZtxL0RCgAImNIPcE+tq+e2poolRgOOPRIHs1pBxv/BH+V+sBM3s7f4YU+9OX8H0A2at1hZZ7g==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.3";
        hash = "sha512-hDL5o0WlZBoavVmELhhrfAzzN0aCZ4AaBiEf0sVjLz38vaArBJTQBD2j7wBcBlC1C+uZB6LN6cWoUv9lh5pXlQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.3";
        hash = "sha512-+DpwBe0r9epSaIrvsvM8IT5Iz/569ZOLjOownkK8u0XSmCs8yNmxGaON3FIfV1aIdB7HtGSSPneDUA5fqeBQXQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.3";
        hash = "sha512-sn3AgxHLlXbStxHCFOvr+JL3vcw60yjBl8j6WKmhk2OsqXbGdkhP9/zgzgITOm1mdgqBkoVJewu5/4ougJZy9w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.3";
        hash = "sha512-5P1/zedTYTZFfEXD3P5dTQkhmzGOCMU5SviRXeFadLmdqnTnnjWfmeognHIAc9MiB1+SUv+Wv0/X/UwXXFOFTw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.3";
        hash = "sha512-YR0lSf3M+jHRmIzixSfXx4x5mGmmcsC+MjqSixnE0BuGX31WmRc7S8zZBdVwvpkgW5OW0pWEElHkl5fwDTteng==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.3";
        hash = "sha512-c7ziBRw/i2VNFG2DIUHDcZrxP9vuWEwAQWH5hCbQ6L0+BRj62O2EvaZb+jzB91+I/EN7eFBI7ajCbJfjGTLrxA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.3";
        hash = "sha512-JGsJdpisXBd4OJBDsTQ2gD6nvMoKXVTPpd4/e6DFIELONGxmkpZR6AGUNRG3rnNE8eRlmH+std8Four930XezA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.3";
        hash = "sha512-mmnKmfBwp0cHu3ZVRMLztTnn2DiQPxQMNwHWr7Cj42KN9t+nIU/HVWnDdZkKM3JQ840bZtjESkh95MYuwp5ndA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-cWf7b117y4tHJoqrWxnSkMI7TAbGv26eh04rqi2jSWsVbLRWjMF4LCQ8dbICpdhkGUmHWuoLUijLcreattTMUw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.3";
        hash = "sha512-nlKZxVMTGnAqYrEIPyA7/mvUYQmPBJ/Bg3fiLbV3smcBYSxGHicrbp8AKCUG+yfyZP5huJj+2BasX47k5FJ8Vw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.3";
        hash = "sha512-ALvoj2Ur92guiHgOuraJ8NOkxIABoz8PPHSCpIMMsxY8Jqo4XCa2qO5ANdtKgswBcS+wmyNWU11QV0KmXIXkzw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.3";
        hash = "sha512-f/t0VPBRgMOrxvcuGKQqm+XXE33RX7rdMgNU+s2INJ7X9yL0DU0PYHDG9EZ4GzegCpEzE+t/LZ0JWWmbWF3edQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.3";
        hash = "sha512-3jqYlicN+DFw7YpAHa21ogbdCzgeKbhJNOegZhFwfMhB+chVo9+EDYBPkMjb0dTvpaNizBM0fvwnYOm+LK2J1w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-l5TIaPzflPeQraGqDvBRSGnODnZ/b9jbRQ+mGOju8TFg5XIWVrbFm4BpTw6gDZsD6lPNmFIkpH9qgxcCVBuzJQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.3";
        hash = "sha512-K+DJxuV8npnI8dKEAPFs722K9fbMfb2yXbs/F4cOLgCsrGD/ssfVX0yI/lh5iZKXnpy708X38EXFt9l/RbfB6w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.3";
        hash = "sha512-XUAlxT+iOv9phzT4sKxw3oxlDyWGShw/M/cGDWiFp7S7xPkGvUF8khKEsSYEkARYsrP4xzOD+BpCp9odm2wLOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.3";
        hash = "sha512-8ml3xZTgBZ3OHdqIPw+K/+Cvng600b/8jdi+QBXgRT/aLaRk8ZTYu+pX0ZBo0OoWFrz8CIZ1SpvZ60S5yS5lmw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.3";
        hash = "sha512-/5uYeQPV8stf1hxNVBKFPvqilHDDGT0wjNNa+gAbr2hRP+4LuNyHVnesPrwWJeSjlxT5Tn7U5RLplh6wOuKSrQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-pPZuTdr8oBLnrsnDXTI/lzWhFLjdu4s+kNgLNuWyZGM6DYva3TJZleQ3/XyORvB/bJGgRn0fwE3KF8/2Q/YX0g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.3";
        hash = "sha512-6vfSREeObTrQWIB/NZ8VpEaYn2QRaXZkEL/hjOMzLsD44csKbOVWfK0o1RPSyiOu/k1JFKWj4SWqXose8usDcg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.3";
        hash = "sha512-F5ZbEj0cvyn7JZ0kN0Z6Er2SujO13r15rEF23FIcK5WLM+3DScBOItGgDmq65eeDQ2FXu0BeUD6+xukalLO3Gw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.3";
        hash = "sha512-IWnekd3aGzLVCG1B/EmB5W/A8fA2PppJS6b52LIdKfA4H/cPJZ6FaqO/EAwIayDOfP9T2FvQjp6P4T2nYEpy0Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.3";
        hash = "sha512-ReHuDAe64uhsOCmTAZVnnn3kXgRBSOrwsNFmdVdlqCzBnvVRssFSEqwnrTPdD82om3OOkvLCh1K/MB7yGzyPXA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-29CFsY9NQ8ILD+eJWqr4Cp6CvtS266K+jvmAoV0jFrVjuIzaufTm/lvmfR32HEM9GgRWjBlYg4svYuYeop66ig==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.3";
        hash = "sha512-3HrmkBTh31nzzQrhDOWsn5Sc8q4l0432qTxOQmFIkWJUC+EIvezH3GowUKzTwul3hhLWFMvnlCdntt0qCZe5xw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.3";
        hash = "sha512-/Y0K5QJ0edr+pevqVUj/TVqzIX8ygAKlT6Crz/uWLDRXxKgY52r+bq2kjODugzqn7VkEKDaZmusEA/739qa5bw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.3";
        hash = "sha512-D0uS5TRm7anSph2o+f5KhG7yzSXgGXy1UAbGiV+QAWnPTZi3hbtZsyLJA6V5FoMJJ4w3a1e8ExbDGVHzU6n+YA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.3";
        hash = "sha512-w5czD/k07WTqkohccBSimSW0WpcpnunM/cVSsDucrrdgrkPnlrDqGt85eS+jIg+RR/h0Z8v9Opv/4U1uJxyWYA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-tJJkCOtu/Nv4EJyYVrwg3oclAHH0I3xHI19XmUuOGNbpZ5WfgiQB0TBuuU2E/7lpDFMIVakbjZrT11WQMInRdQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.3";
        hash = "sha512-2QxY/wCX0m9Hbt2wWYzR9Hq/I6ILWmRLpDn4WMLb4Vd2ho80mKfd2Voh908gcCxG0KhR8N2eKTHRVhoOCBNk1w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.3";
        hash = "sha512-z0F2wqQv+SdwEtJrgW1qWnGKTY7MpAFRPIcLkoQah7aSnPaCwzBTnB45Ma2bt/UyVXtthBQSitiwCjvwGDCiuQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.3";
        hash = "sha512-s5eKxAGu7eFpWdVysqRuLNx98mp9dmR0ufMxmwjBnHXj2vWgKDUWDUjnhnqAO6CTVpoo4UEU0AVfJszwk6aMDA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.3";
        hash = "sha512-/rjhycNcX7szG0A5RYW4XA7YT8M+ia6zWxYT8dP1vCuLGMuIwieRXPa51+a05WWCftIX+wl0ENY/7pXn/fNMbw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-GFZHJrtpt7+Oe6wAr3t2dK9w3fjC5mNSiVnMclLNdjNFOAQaGmEniJCMPFZ2924pPv8BmW1mr3DBnsDHiyWRsQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.3";
        hash = "sha512-cGfAzYG2IYhyqEW5JOriA0Mc3scIZs9+ZiUwL6lsPcC/OaHzljN/5uWzCzJz47rxIm2fOHH0J7yRZdaMA2pRrA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.3";
        hash = "sha512-aFZCAn88XX547fjn7eoBdSEMVb0ci6xWMeCxIovWrQiIPvBegyPFftqifZoD8h4c2fV1veKAKjlh2oBIUYHCog==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.3";
        hash = "sha512-uZLvUPYsqG+5EUac4JdnZzH63Vx07gqOW8cxWT24j0ZRJyLtIWPZVkVHbbIWt6SL2awPodAlAubsXEYHoK+zPA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.3";
        hash = "sha512-FGXfwG27Z4UhmDqzgBsNpxDCiMeI+k1++Vba6NBXonik8rJGIzG4rQ3JKA/faude7l9SL5zNWn3wWjVSTaGLsQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-/xGYDQvjvv1ep9t1SnHn76P1hAaWLDRXAnX3Lq3anx7kz0fm9Z1AbRqhJ/ZSDOxewJp16UYrERvwBXXk0gx66w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.3";
        hash = "sha512-XS6/3DgJh2W7ycAkWTdS/cM08XBYqyoP0NaYUQS0fVAaAUXkDb4z0sTX7ei4nRaIts2HEw937WCO5HdNNBj0qw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.3";
        hash = "sha512-6mMD7d4b6Yhj6IfEeglgMmZVxQqyFbzush6SZBSW4s8aKX3kyVNh+Cfn5ITzGTQSTzsDoFEgTOn7ti4ayuD4Rg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.3";
        hash = "sha512-vTxTUPfqYFJgBQbhbxevacSHL1dZj1DWccm2JOt53Ki5571A5kqmGtUNHWGQhMy3i5RSItis2tctPURBT2xKZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.3";
        hash = "sha512-0m99ZWDyt47tdR+O4WUpJCZmzf7IEwI5oTvu6DxziFO8SZHqPlqAy8fLWrVL+d0UmK2W9G3VKUjqgLeuszyCEQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-mUnfZzlXfLEIWzixK7Cl0OS99nVREJKo+d76TG/efH/ZcJnk3gWGJzRd4mApcYXu/J6mASYuKKzwTv00R5KGAg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.3";
        hash = "sha512-qg42VbuD6mJ3zGSWn0SFehbXCCXAWMQqTA4t7SYOWGJAcXbcoGhOVUQlJ39uQoR3OmiEP/euhgsL/776b54HsA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.3";
        hash = "sha512-ncNLgaAOZXzGuFRUgbQDJFJkw2+0PgRZ0zBt0l3Il6s+9r3QyCh9v9bj5seVaawaBDgaz9Rnha4fXX/j3k4/8A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.3";
        hash = "sha512-IhCisfAOoMakpQ6TXKC0YgDoi4lZQkJIg49KfRd8cq++QjId5QYYlRLV9VaWQoJiFiATuGJzqaI3RhT1+SzXfg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.3";
        hash = "sha512-x3CbrOplS5RnCW6i6lszttctQ/BhGJv6Xul42gMLtZumV2dBo7IGvIgOJhGIviKTbJPOzQSD/EGjNScNyiLpxw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-K2CIuqBa3a+fJ+LX5Q3OSVBl6OD+sdMBcNr4DOwUklpbIHV5sjFMfXl0GzsrqPTuGUTygv/PtUSDeaioGIj8jQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.3";
        hash = "sha512-whltnvycYULmZ52iz38DBKO0XNOlrMyTu46nlwHdsrUX23yCm0rRUSH/VMYaX16E1cK0fLnIq+1rPTUpAmHTlw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.3";
        hash = "sha512-zqycdmVXgHr8fiZo7+Q6nWZiyj3JfUoJBfgIo1s+AuOejSes9TvYhlZvR9hu7BjCaCimGt7S4WHlfsrGFNTvGA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.3";
        hash = "sha512-Smjvtcx3VpT11VN4p5s/omKPhDSaTwr0qZ+qCHWAxRnuzOXvMcT2DhlzhgPaTcpyJVxxr1LLsPE74bwTfCpDkg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.3";
        hash = "sha512-VVIQmIX4KekyiMyJuBJKjfJk0R0NhmBQiw80XArJmXNfIhx75RbntM/v8RW9RGLUKLgBag4momsqu7z3xI2d7g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-Cv9VzRy9QWbwV9AwWVABxVeX3S34F4t1fK4gDlRH3mCLNxow2IZ26y+D34PGcQLPjjm3homPygKE48t5FwbOBQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.3";
        hash = "sha512-/ta5GNvNl6yd8oAWi+K21w5LP4puT86dWEtSyA1+FcBB4MwN8YBb031pYNTbZYDa+0tUTraSkgYN/KqjQKzUlQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.3";
        hash = "sha512-f9fcDsZdGBzYGc+vEjxHvBYkYDp86uYQMqc6v+NPp3eWnHbGL4Bz0XCNkno49ZSFR0tTOgDURsQI4lP7EHuCmw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.3";
        hash = "sha512-z3ovVAXDqPcfJC8Zff0JJ9eSuHROZgdVp9/c7RChshH9hnfvxawT/KhdCUIZI4otejrka+MjsVQ7sjIj04A7pA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.3";
        hash = "sha512-U2s1MoELci9kePlBNUk9vfgrMPbOAuONZUcFz7iOGCKR3iZQQ+8ufWvIzaia3v3FBEsdgvaQDi6jkucM/dieSw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.3";
        hash = "sha512-81A+vYt4KvIO5LuhBYvX5HzaUH9Myh5ewf3MpunL9lzb7wkVwgrVWnT80vMZYizfuYS+/tHLUX1nH9aFwQSCZQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.3";
        hash = "sha512-uBl+yV4j9axX6biPOF/tOMeC7+BoBOFbbYC8+l8HS167ttGi+lZKr/ce7DheYKeYlyj3lhJU5+HmoIwH7l73WQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.3";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.3";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.3/aspnetcore-runtime-10.0.3-linux-arm.tar.gz";
        hash = "sha512-4WtDt/exhy4httXjdxqv4RRvzzrCKUPPUleO2gS3EUKxxOkOY1or1k3aHtr26su9AmEdoDvYAM9T4xz6TFS85Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.3/aspnetcore-runtime-10.0.3-linux-arm64.tar.gz";
        hash = "sha512-bBdMRm28SVusamup2umc3VGFmZ3JHsqdtUDKQkopSkPUeZTEy1tZvBJUUc5NVnBoPfOeL5ry8PC0VHqBD5X/0w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.3/aspnetcore-runtime-10.0.3-linux-x64.tar.gz";
        hash = "sha512-pLz3WnNMcquH81buq/28wBIS0fpGKb8szfj6HNnpI22vD7Y0ma+lkj3lZZOq5XA4KD/7UYxnU6ILNFUlKaEcNw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.3/aspnetcore-runtime-10.0.3-linux-musl-arm.tar.gz";
        hash = "sha512-vf5D0LuMkIIzCkAm/jgzIXNrQ7G2EmMv8NKVuN6cDWJtjvgtzTLIliTH33xn7FdMhICAi5m3NBcAi5HHTQ+nfA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.3/aspnetcore-runtime-10.0.3-linux-musl-arm64.tar.gz";
        hash = "sha512-CvCzK6+VrFG8mPlux2b31iGGRCJmUJz0AxbnGE4ex5Q4bhRyI9VDNAvmD96uXDzinJW5NmZHlF/O566xVYjPkA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.3/aspnetcore-runtime-10.0.3-linux-musl-x64.tar.gz";
        hash = "sha512-AiGtbtYKiEJfUn/tsNrygVysD+74rn+zHzPlsb9vE0RETj1dqlYwnR6YCLLorkKI/YDQ3ImOyfH9lasPw+g0UQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.3/aspnetcore-runtime-10.0.3-osx-arm64.tar.gz";
        hash = "sha512-bnsuRcKJDC76jP+UQyicXyyYnnJZUVdg+rjIA3ldgCAKF65ah0ma4lSoSlFYFv+EWfKouvbcuOKt6dg7WkHelw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.3/aspnetcore-runtime-10.0.3-osx-x64.tar.gz";
        hash = "sha512-RF/L2PiadxOr9GmDAv5Er71WbOPuvdSJz2pS70WUSy8Vy+bpn5UJpPtFXvNXNEUrL9GqWlcSzQ2RtsL3Menodg==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.3";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.3/dotnet-runtime-10.0.3-linux-arm.tar.gz";
        hash = "sha512-xULS7Ht/9fLz8y97n1G3uOn1ojDk/rixaFWS9rj9PciQEJokZCHUomFaKSnosmQYEu8CMUHbRCpiiXKVwuapxg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.3/dotnet-runtime-10.0.3-linux-arm64.tar.gz";
        hash = "sha512-OFL6tgGFClXYOQtdzu6fr4RD5pMUqi3LlmLeKK+CCRRyU9aPpXMXINxA91a0/9CgBxcrRv5M82MNmfeLFILPUQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.3/dotnet-runtime-10.0.3-linux-x64.tar.gz";
        hash = "sha512-hwWY8SlMCgKXV2RryC/kGRbNtt9s/W8YtEh7SOmgNItxe+ZZ9c46YVPT+N0zJuxZoWY8CyrpH0UKqetLXsXUsg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.3/dotnet-runtime-10.0.3-linux-musl-arm.tar.gz";
        hash = "sha512-JHtv3YYdvE9LNq//mHCtUumGS9EiwaQvT3u73CQw99ms6RktYNVttj7M0vEHs+Buzfzwko9h4uowGq+lREfRhg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.3/dotnet-runtime-10.0.3-linux-musl-arm64.tar.gz";
        hash = "sha512-KlzK2dxDrtLzgdM9DjgeR/IV0HOxj7yK/i+mZAz4prt+va+uOK3JzKAt3Zd25g2130Ufvd5dsMDxR6VcLxgVeA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.3/dotnet-runtime-10.0.3-linux-musl-x64.tar.gz";
        hash = "sha512-hA7GtiS2Xhp2rBI0m4ock+UDXCEzFYieOqzT+Jksbk0cGE82bufexn6HzeR55674eIpDFbVaZp7UH56VJfGGfA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.3/dotnet-runtime-10.0.3-osx-arm64.tar.gz";
        hash = "sha512-Po0hx+UVJI/LwXZJu804Abx9ujCx9On7GM6QicBTkmFoEHeNCoeRl93rOJHFPKrZFnfNOUMUpEzZ6tEojk4NYw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.3/dotnet-runtime-10.0.3-osx-x64.tar.gz";
        hash = "sha512-AzcWcx4XwRn7xq9joXO2Rh8JYajl1baUGrGQdV1IzG915aYepw+tMEY8os/N2uHE/PzONNr7HSc4KJAZP7wswg==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.103";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.103/dotnet-sdk-10.0.103-linux-arm.tar.gz";
        hash = "sha512-xutZeBq8eyfXI8c13oZ6fbcFLfjpVzm0Kn9L/eepfRZ3fLIXmkkilV9w+j9t/KBcEc2Rur129pBPhJZ9m+D/JQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.103/dotnet-sdk-10.0.103-linux-arm64.tar.gz";
        hash = "sha512-q0W2uurpVuRGUVF4fYuBE7Zmee1V2h5yxX6Zqlq49CRx6A3Ipf0iwx33TmBEajslLSkAZYzvyVBvyw2n4oMeIQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.103/dotnet-sdk-10.0.103-linux-x64.tar.gz";
        hash = "sha512-urlPE8V7Ksgh1JJP5mCEvptExBdh/3/2RSLI96ujRWWdMSWEAdzsMcw89syuHQEmIwdayhybkWW8/lupq9ocDA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.103/dotnet-sdk-10.0.103-linux-musl-arm.tar.gz";
        hash = "sha512-b+4TQf7bYN2NJAyX3ja3MIeCtX9bMlaRChqYuxv8dHKEj8DBkt25pcldczaArW2ddBOfEaivs8RC0vem6LhMdw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.103/dotnet-sdk-10.0.103-linux-musl-arm64.tar.gz";
        hash = "sha512-kF/ToNUxk94QtLC9Lu8FrdoirUCQyuM197vwZOM8ojp1SFXsfy22FwOrrPFC+7nz+yfhpv5p7vH4GG+g/ZbuKA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.103/dotnet-sdk-10.0.103-linux-musl-x64.tar.gz";
        hash = "sha512-/Ms2FGHYvzC/7wHTxpz/ruqfE3JPSIBaasWjnpx95nFBs/kwLM9MeeOkQcm9o9S5LqhIF/jRVc/ZEvk1fCkdbg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.103/dotnet-sdk-10.0.103-osx-arm64.tar.gz";
        hash = "sha512-cq2BjRZcGgeJi4H5+YnXYd/yx7e10hzCoVFiHS/CCBx7vgZstZysZUwZNzYDx6Ep98fHoRzlG9HN9I4FpN54yg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.103/dotnet-sdk-10.0.103-osx-x64.tar.gz";
        hash = "sha512-uMm9FmCyMGydrPmbx5Ms9ovdVDuFCveSApCewdQ6aXqAyVSM1MtDvRqF8JI5zqePCZbiAkrjiCv1LxnuI88DHg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_1xx;
}
