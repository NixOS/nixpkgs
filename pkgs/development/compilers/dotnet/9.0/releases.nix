{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.20";
      hash = "sha512-F8RZaC5ENrYhkFhGlQNVGulN07PasAi7fKwng//l2vfbON3sjeMHvF6uJ5PFNc6wNyzAJ/OELMwUiuo5RAK50Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.20";
      hash = "sha512-KkyI5zFBsoDyCImPXeulJ6tUprTE9bb0DV5kvfe/8+kAtqqwAsJXoMgvFpJFwZFEYqGwgiuDhLuCA1pBUPk4OA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.20";
      hash = "sha512-8TKv2M85M/gbGNvlQAg77W2kFkHJ79rjjpkT0b92/8rz5RxfmospsQAeTpECquIP3ch1yg4d+B3BdmjHFymqqQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.20";
      hash = "sha512-sAaTN5IyF02cZpd9PKuLfxinYIyNVU+svnV6obYAqHAh+HgLucGl2lSSWCURjVzxPu7Lj+En+tt9/290rLqwvQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.20";
      hash = "sha512-KKQLfBwHbSybzNk647Kk+rn8iiWYx0H2NQMfjT5n8Bc5hCOvotwzDdVLe/jELMmvcWtOb9FNxJdQFti9oDtaig==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.20";
        hash = "sha512-ShyAp5Vrn3TkN1o79qfU4wzXEfO+mEMSXlvLbNTdnqSGgBrgWXu6Md7sP7p5wyZNSXSpxx6/lFG3nDlqv48YNw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.20";
        hash = "sha512-hbcxgbYk1p7Fun8Gkq5+hVd+kgf9OtwsZDyNgrYqmz+E4cx5YvTk0TYGo0V49rtTqEl8hkNd+FOBZfn1geRrUw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-b4HTAl6FLb4mi145KBZx9kkt9MtgcnAp5kJEKi/F0nwWYE+D7rr081x0FSIudMqW1xh1n7A9hyu2syBLcYoqxQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.20";
        hash = "sha512-Sa+CxheFvErWZmo+/+hXcWM1p41sdm3RZPyVnTIMzQ1XZBSGHcdYhUeQQhrX/DlEnN70KAt3NMfxCPwznyit1w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-GQG4JoxIiDZZrXaNQk7nYJ4kIMxoQbS/wEQCVZQN2w0ZbaaTdxmzkDrRBTa3BUwI7vpNS75hYg4paFLwv88SEQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.20";
        hash = "sha512-C2nWO7Hm/HUBYo3rf1+p2wE8J7G04qhe3hQmA0JFITtTGZHbRY+HGzsNxdW7MDpcPmPCzLObAE4PgW9NiRLahg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.20";
        hash = "sha512-PezqSiUM5OuOL54AMSIw6CsnaxwLTn3e3xyDx/QfuyQ5kR85fAyxvyukbMc26MCvvmonVfv4tyTEmSsx0Mimkw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-rS//LkGzhbuPNGoj3ZeOWBoWh/M8jxN3rjpfmsA+Us6bPGJMduRxsTwNTiZdCGxdk+99/D8NlXoKTUz4ZpMKFg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.20";
        hash = "sha512-WrfsT7A64rpfhgGlmlHC8n1pMtDQG3xEPbxMNIT8HFpvAPSq/OizGzyXRV3coZWpwm+iKCgzvM3Hnd+6GYOqSg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-l1dJCxLOd7RHfB3RcBwah685SnU6hfc0K3tyUa2XaT2qecI8TcUs+MpRofi4WhVRtG3LOVihYljGUn2SBxde8w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.20";
        hash = "sha512-2Q8F1FH+3PCPY+HTGPkyGuFVOHeVVkUFT4EGnM0TDXjmxopHxnR/7tJWFx0t/wGKCepAlOFI93AkO8nfKPOLiA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-3YXVr7fbtPC2H3Ny+X8kszjDsxSjwGQqgg5/I48/m7vuA0O1mIcG7z9poLJ5yeZSzYxad1OAl/49/3iPXv5KXA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.20";
        hash = "sha512-YngxfB1iwWptOcblyAORzazZ3e5pQO5rB76Exl2wBNaBNhARlqBPFB6K5vZkeYyqZXkGCMleHQf3jQxsxt7EPA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-pCU2rtmnGKFKzjv8ZU/PFCafpa0cGA/yhr9qkmw6V2ZF7O0fHTgEeZz92IUawWoyxM2MEt7p/Vq/KxaaME1bIg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.20";
        hash = "sha512-PM9gJh36oaXrOkidfsqQVLtJt4/a4htHTzTXrSjpZuWU35UXV9JHXMLfZnpexciUnYR0COHSoytETsW20WvY7A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-3VIvBVPzEhyPngEFW5CJCNFoMtI45Sb/QvF5TmSqyQJAp96MGv81OwkDX4CZVfq2MZ8C3luY3LqkEvkfnlWhww==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.20";
        hash = "sha512-dVHkNTCGaazY8kVorZPrna55goSeNYhJ95kictrpdQakKv3tVQz+S4GWQ6nqeozUla3qqOcrp3LRpbtOWpyX3w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.20";
        hash = "sha512-Mzeti6S4U6qxOurY0dMNffv4IuNquoy5KD+CryvONKZ+g/It15/N86D3czU5RXovUG1DdYGXaj88fTfEWQtRIw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.20";
        hash = "sha512-B3U7wpLo7dLNv4605KvayIT3pUUtot4GMV3BdMLcv5jN1CVosK4bn4F3IfCe7w3ZSxK/nP+2vQ0w+L0QB2gpqw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.20";
        hash = "sha512-VAqaXe2eLdgsug7bvHnGMJRSEZQIaeqgJgL99L3GEz3JlDx3srtiDux3LGEAqn5tNhDWAO6KKuxvurlPpC5Ybg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.20";
        hash = "sha512-ktZaSFGkwJ7qlZjZhL75eT4GU0ulRKsfFILH7qrdrttKPoMUgPSt57zg7FqGS24+uSsbyfpZ7smLMKkesd8Uiw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.20";
        hash = "sha512-jCy3pRlZHg2WyHPPlitn259m4eAEZhy2IStA71zFPHr5KRDqckTuEvHpp247qzmzEBZPa8rEP68CR4L32ylsew==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-YMfJX6z0U6fhQDEIyGJAW22zB/9AeTAYSUCTBOLB3x2NyAULRmD+SYNOCwl7183dhn6F8jGtOXWL3cF+3wjLMg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.20";
        hash = "sha512-WuVdo2synp6FvgdG/lqPQJFyV0ibLWG5ikhuHnnBbVrJOkynE0rTwvlFVTzXs5CgSw9ofH6LJ4YfvkboeYMALw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.20";
        hash = "sha512-BafZN4yvZT+Ym4uMuiJJ94+Jo3qL0Hj8P306cC4srN6KsTIfDIIlPOKpTY7xkt2lFBxdAleZC6tpO48uUA11Qg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.20";
        hash = "sha512-HjcFldgON2envFBavS5IBWrW6u1ndumxZfXjI0ka1m7GWVwfKR22y2i0uQyc8uIKecwS1oSM2rzOoQqE7zBcUg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-y59sztN9cUfoZRJpOjSCjTAt/GlzlHYhkTCXIAr0SYnv4P+3X30l5djiRPj6bX7R9QBPSJWkowZm20s8R+wjPQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.20";
        hash = "sha512-u8n56IOjhI8pLnsnZU7snwu3asbNvCyQN+8/HP7Sjyb5GaSpQ5YY37vtqT5CJbXI5BZ3LoycuVujeY13IkkzfQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.20";
        hash = "sha512-cIW3QsawWaZtS7HAy5K7iIIgsUcHh7VLNPmf5FITHXGdxM3RBQxrrhzp+6dx/Tkp9V280C2J1hBWA5Zni9jaLA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.20";
        hash = "sha512-RocDCVAwkTzWSju0emSAYEKZ4CnyrluOmTz8slUoWC8CPaCimKQ+uNrCk6dEO7GvgNZmsoLIE+Y/GIEKn11bJA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-lJ/E7d7etV8OnqvF2O0Mj4HmpxpiDa16qR+PMeODfaImsyqKr1E0v0w7EACx6iVylxQaeq88bXQKbT2WA6KpiQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.20";
        hash = "sha512-SEtWIoTSh5VW3MDLCC5qg/gbXiR16DqxwjuU9RE27BqQ+8mjNAHA3d9SMw2yNbHuQpRP0oUYntlh9010qIVl8Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.20";
        hash = "sha512-ocZ6K8YyWO48FK79tQ9lRmMKSCbQ0894hXbbbL+hD8pEgPVESS8GOEw6wnD5Sp7yr31bW1tpghmVwbdc3muaqw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.20";
        hash = "sha512-O6CZZPUwyEYo2FLp1Oe+hna4mNohspsvd/SNv3aRIJZ4P8s/SA5WATjZ/8CmmE+7RFQKAE8EvgfQpqjHgpp3KQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-wiSEIvRF42X5UlnMZ0ShEcz08nSd9YfVP7Vl/dZucmuS8471mX2Wqhps/Ymi+Gf1G4IAJ2lviC7MqqIsZUm/jw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.20";
        hash = "sha512-q7aHC+YV4PvwjgY4lcczoVEECJIX1qW6PtxlHGd2YNMhjmT5+1yQ7Qtf2vS9MfKr7YLQQkuYgCOkby9zxhMimg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.20";
        hash = "sha512-SKh+88KPSnOgHVUoqVNF8riaP1nvJAy3WV0AGVcDAhqv0nEKPBlp7Mrev4SAL3dvICq4DuS4AtDDp94mAhx0fw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.20";
        hash = "sha512-cIoYpwKabVitYtKvJgmqSmXxjqnInNmaLjMJM9RKDClim90FodJiuIwPHOTVepBBJMVgVYO77I1/skXLcKI7qQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-8ywYbfJgoAODYIWsvmkrGvQR2MIHgHqqbUr4eg2/aETuXc4XV+ofT2ukPC/jDr97IOycfADlJpyym1UIaDOsng==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.20";
        hash = "sha512-GT6lc8rTIR+AgoCrviVNpIAAByS91HJAcwH0MI99VK0ywAUdRZycFgrcjYbYxv/FbCaMZMejyshRS4RLsyh4sw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.20";
        hash = "sha512-V6a/NnoVZ9UImWXEINq5DYYLZAIfyqMIcAbdnro8t/a1HoaEjJ6pBoaN6lap9xMmYyMoCepm+4EngooWhP+P8Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.20";
        hash = "sha512-207p/lnWg8h22ufxQD+E9VOjlfAVAwuc+HpRvjQK1RO4YPtPNBTN6FQjf3/lzuBa960kXdlPR9p3UoeIQp+/nA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-n5BF+jjNQgJ1svxbyJ8i5FA4U6kLWbIDzKKIHnrmEMDDUTt87qcE2vIz4U11WRyBbhMTf2iEF7FYAu9fm6PF+g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.20";
        hash = "sha512-hK9c+Frtcfz+UcY04CPx9Ji6/WMrxXnliocE0Uy4En3h+Vh4nh3CkyiLB63YJMVeK/ciEA/DeW37kS6EnU//Iw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.20";
        hash = "sha512-Xf5TUHwEMn7B+bYTAAUGaSh9V9OlBp97TPcwYI/tOxbSVenMf4jU8aP+NyEbSO6ECFwb2n6C/mIk+xbkw7WWkA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.20";
        hash = "sha512-2pZT34uxcX3EwCbtoxMXT3NfOlZ1LXXWPJxfkfRhiBD0kLqKyTZnrnr1fr445NI7MD1pGu+JxbbKIhshqnaQ9w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-ymrDSmGLnbyN49MyZ3o5b9IaxHXYHXIqVjtQbSitLmvTDhLvCeBVou4+OKB1IyG4GiTofAPBEru1q09QTwX5MQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.20";
        hash = "sha512-nqn57h9XUlSImjGAZKAehRRCYe+NPYTJrvVy1EowfRBtz5erV8Bmyna23m2FcY5/JlvNZL2wKTByxsqsiKOq8w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.20";
        hash = "sha512-9sYOtopTb164J0piGo4vzTNrCeEBNhtJPoHmxAY51kPylmyYlewP2eMvdgPgyDsG9K7C817gQKxH5iXfmWrcSQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.20";
        hash = "sha512-EeZ6KivP6+oTXjkRuSTCSRcRhfZPpFjqZ8o8oaxVjySeJDGb5nOtL0ligsxNMH3UaKQNIJXHzsvV+XAXP8zJzQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-tks87j4vQdgFvEXPUmVz9YRWzav8X9i13K2k4k/FIg4HCBp2Rm10cADNdNPoAwpaMuWXLx2nKG7mUyDf43RRhw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.20";
        hash = "sha512-7H/U1lu6HMaP4TQjJ8mrt6BFFW038ewCCYrTc1MVH3Y/iYIPoVEsf0GYWK73Sc49NrGWNNWFb5QSuGk0WGzm2g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.20";
        hash = "sha512-T3SyesUGReQKr8EHuhDyg0nw17/2sU9ikRwG1OZe5LCXMBf1VwxwIXNRalyIyWC2reEEj/Un/xd1HTfZOD1PEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.20";
        hash = "sha512-vPaO2R+ZJArA8/K14/qb/7+7rZTtmmLhCvnouO5PwdXfsdRBV/6AHXLWDeuogT6CzKo3hGhs4FZeKqbdPrhF3g==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-R6jaLukcuxsNSx/vIV7PPBGY4PztymZdMyFEG0s5hv1o9L7FBnZ0G+ZnoIfeuESUMKRw/TSGU0BDICUQtISTiw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.20";
        hash = "sha512-798E9t8CS6i/i1VQAppT66cKtgsE2xJIVZ9mycnCx3VTMtxNQiMyuvxKnsPqH02MnXMvZG346sLMdlzM079Q4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.20";
        hash = "sha512-AstelnDEvi9GQ/jsEryI994dSHuQsLi2Ywv7qzOMqgvJw6DNFzRCyqGQJQe5cr5awsmoCFzX5mJD96Dx5QJxvQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.20";
        hash = "sha512-SNDSBW9i0Nnj7c/FtaybqdAa8IsMUg1aGSGfm2KRZ8ZXjp8MGiZgUVwdPMx9rq4E0CL7Cvq45SfaOIorItjJgg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-X6P6kWeSfHPVOimo4Rb9LllfFC0k2ng1LZ9/JkiuSQydV0R5rTwabTSoage9acANkTAKl7Kyu3ThmnwR7RI+fw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.20";
        hash = "sha512-5JWVbBOKDcUNvDqbDAKvCg8VkE7QxrgQ02lzZEuaNYsPHOqlR74EmwBUjvoBHQiLG6Z/2V+5EfAO0mjl2DrARQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.20";
        hash = "sha512-h1LoA+ZvDxxAxBjgYvGdl1NQOTb1YnAzmoDFgpXaRyveW1vRDa0L8HqHhtvKzEPmrzxCm7cPS4EToJKy3gewyw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.20";
        hash = "sha512-BsXABe6swHSlU36yfHpp2XtSBXC6zqrcoIPFZZX6liVZ0xbtf8QZnqLHhvNSYrDtIvPLO+QJyiAXTpNvdopxtA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.20";
        hash = "sha512-jfNkHNji55qsiG2nSn1h3kHbb2UFGPRR1YnAL59xk/85SlPlAydwu1kekT8vCKbv53MiXareABt1Kl1kBXDQdg==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.20";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.20";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-linux-arm.tar.gz";
        hash = "sha512-KFMpXzgv129BY/YAkfIppG7xahQPf7FNkD5TPikeudHRTdXNYCBRlxnOoxcxm1gNiPtO/eGZk3x7WEbjEmuBdQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-linux-arm64.tar.gz";
        hash = "sha512-Xr5NTne1u9IA7cYZCFSk0tV34i3lhbOkU7zL9AEM5dxaz7lR6ny/UAnwmfI6icinIf7TlhxdarkkhnTfShOszA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-linux-x64.tar.gz";
        hash = "sha512-EdzlDsWhydqyFtqo11TMFKOrH1C6Dn6gzzCVxDdF9fLCIxnW6X6ulzq/C58uKiYjKVm4TEgUmg9hBuSvcHPeLg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-linux-musl-arm.tar.gz";
        hash = "sha512-f9KHQTx1PaHh1FVLaElMFew2k+1psm5icDN7pik++usuFYsZ/G+eu4CRhWW2O72uCC1vmQMQ56tpYc2H6LXUyg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-linux-musl-arm64.tar.gz";
        hash = "sha512-qDTcHVAYT5ZR6AHa2kVtSdYvf0rLbn1z35bF38BDeXc1ZoxktpfA/agQTrJ2Tm3SR9PGJ4nfqWdeJYo7eznzxg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-linux-musl-x64.tar.gz";
        hash = "sha512-jBt4/SRzrWqm1q8um5nOQFZ3xqyCr0zpzj0cve2LP6MO34Kts7FxI5nYN49ICtw60qAptdF0FW1Bli9ZTgxm2Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-osx-arm64.tar.gz";
        hash = "sha512-t8908hCQSsHgmxWjE/v1lms3U3jMh2LxVQKl6BhXcHGJFeJsjlmzLIKUcB1UtJZsZ3qcQUx8L6CkDh8nMTDIhQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.20/aspnetcore-runtime-9.0.20-osx-x64.tar.gz";
        hash = "sha512-CGt32FFRLMdQY3pMUSyqzHj4fOhL6J14laD9i1wiUzu01/CYDc0z1p5/3qoQbKjfSGDaPEn+nhELQ5xpFjCm2w==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.20";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-linux-arm.tar.gz";
        hash = "sha512-0Z/YX4/yqxBCI5h7CkIl7vN863Mi1KGtqgUO4JTgYK3PjkRuxKTuqIJkxMVVHXfZtoHUp/nSmKgvOd3SzuVaKQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-linux-arm64.tar.gz";
        hash = "sha512-c+JzbeGMhOHlqrcYcv2NSL9Yv37h94GigIkwjbjX0/MJcANHr9tM4+eVmipsxUsNHkblqkzxTZ2H6g0qRJb1iQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-linux-x64.tar.gz";
        hash = "sha512-qqY+kVb8ydHFHhX7OOPFOIp3Ie8bZAZciGWwMTOQbp3pZ64zkDwZjGrLmqi7rjc+kAFAUHQAnC7yoLtuVLUJpQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-linux-musl-arm.tar.gz";
        hash = "sha512-c2AgJAuBi/m0FoFmYGHpHevsaPnNIMVBs8kWaZhLYlUnBGO/nG2PbLG88CyPAckyp2OWkwxuRKsR29ecEwC16A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-linux-musl-arm64.tar.gz";
        hash = "sha512-s0v01rQN8djBz1JbR3GFqxhitHiDvoXXeg1fDMPHmDrCCEWzzy2Poecs/ju1WQNQwCc5mjjILkRT5EOP24U7bA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-linux-musl-x64.tar.gz";
        hash = "sha512-5W2ZDLAKawNXWWwzt08TF9nUvCY4b3/Byo860DYo4pGx39Y/IKRsGvzvmQ476/ky7kBEQimHS/S5vS0FArQzEw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-osx-arm64.tar.gz";
        hash = "sha512-W7Z2tbrCZW636MhHUyUFAHshVN8PZoLjGxaB410bdXyiAVWWd8fiuxl6a3VjvFhNf877JjRKn48qOQtBE2onAg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.20/dotnet-runtime-9.0.20-osx-x64.tar.gz";
        hash = "sha512-tjPjbzCvQNH4EU5uN3+TVRKGEF/0u5+IcTVVmDOZ7bp8yiHse4b3Smwd67iYyOxj7NshSziGbFa2P6w/+MP9Ag==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.318";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.318/dotnet-sdk-9.0.318-linux-arm.tar.gz";
        hash = "sha512-KNQTX6Acx/xTg87qVfC/B0luYIN1uAdcCFJEX4ZJNlxkdUvVD6Yg2wXsm3k/j2r8UOGNij/6/Ed4h+vTjiShsw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.318/dotnet-sdk-9.0.318-linux-arm64.tar.gz";
        hash = "sha512-+clXhnvd6o+C7ARZQyzn3f+Pr8hGU3uAA+ufI52cLjhYYDGhWVTnRpHFqM9bOrEl2ZvKhcdMpF3IdFBxyoHn/w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.318/dotnet-sdk-9.0.318-linux-x64.tar.gz";
        hash = "sha512-6GhSk6NRIXjg3huzwWY+Mf3512GvcFCUv4M8wf9rmhjFQ6pBQfAhZQPJgDnHGVhabTKQWwu7MnnpO352FuBHww==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.318/dotnet-sdk-9.0.318-linux-musl-arm.tar.gz";
        hash = "sha512-JZFsC+L7LU5NXjAv8aLaqPTscsfxeRRRgPdZVf5+Yvt0PNf9rP+1b8KA/oARqLxQQ5qhmFMsEcoCiAXY9BkNUQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.318/dotnet-sdk-9.0.318-linux-musl-arm64.tar.gz";
        hash = "sha512-lck3tbz1jFXKzcK7XNCvvcIC8IG+Mu3oqX6KNQVyWxa3+sjnHeVUNFhbCUZeGXcy+ieFvz4TyOoe20TeuTsaBw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.318/dotnet-sdk-9.0.318-linux-musl-x64.tar.gz";
        hash = "sha512-ruIxX6XTt2xR/xJ/U94IgXqwgLgPzER8CkPE3HI8HQxOTM4d7qffACwVnyi3nuo9Ou3l9prwzeMaEpEQQXK3Dw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.318/dotnet-sdk-9.0.318-osx-arm64.tar.gz";
        hash = "sha512-QwXJKQBfR6kz8zwlO29H+LIf1glsfjWeeEleDefI7RxnAK7CeFqYPXasfJmmaxQiq+20BWJZsA50j/vjbyQ1Mg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.318/dotnet-sdk-9.0.318-osx-x64.tar.gz";
        hash = "sha512-CLRegre9ewgEwU5iKbNwP7j5jKusi+w7BdnV7MQQM4AeRVxF9LWoprrA0EBbZJRqZWFKYRAXt1lqglz9inSuHw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.121";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-linux-arm.tar.gz";
        hash = "sha512-JqGtiY9mcPreQ+FMOrO+5642Wg2Nj9+RIGj3PLKRMGwq3CvNM90IA6NbfrVtCNVAAMrPPyzXl8zDFSTMRl/9vA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-linux-arm64.tar.gz";
        hash = "sha512-LIKIVo2YJzcdjQ2vBXhZCpVtlVvveDvxQDlT+KgWhR8DvnqjZrZknnzad6jnNZrD/Eb6yH8BDXG250FalFet1Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-linux-x64.tar.gz";
        hash = "sha512-1m8mCbUJpO7OStjvusSeY86ljgdlLx2t7XK70QDXD21dWKm5W5I14VjLexp3mVMRl57E3fLfTGowF9SnHxY3eA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-linux-musl-arm.tar.gz";
        hash = "sha512-v5nqMB7nuIuu4hQoB9H4EKlomf8xUleUuE+ugM6TtMPlklIDpMnbvWPdaEStU5t+KbYmLyzhh9NN8dmcYcw9Xg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-linux-musl-arm64.tar.gz";
        hash = "sha512-QtQXxg7/AX1Ng4uG5Wc883TxrDmBRXSAWoaUnam99meFgLddZcUO8Q4YAcIxPxVgjvXHu8dr6a0VYLtUvpBTmQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-linux-musl-x64.tar.gz";
        hash = "sha512-lZ49KIdUaanSKYYv86XgrtymhkKv78SoSdohjHzoqoAO1aRAgM1xwUMeN5SZtRsR7Nvd3QtQuHTPamVncx9T4A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-osx-arm64.tar.gz";
        hash = "sha512-bjSq9dvx5ITL6UsIi8Jc+2b+IOjN9aFBsEccoVAj4Ig+BWPaO7aAQSaK0/wldUn5AQ7gReHRD5tlglbokvldLw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.121/dotnet-sdk-9.0.121-osx-x64.tar.gz";
        hash = "sha512-7HEHnrSWczmgfpZxXucljIqQfMaoNLdV/qwdgiRuS2GhSEb1q0OXY3PAjGATbU7HwUSlVN6C5ZWBIId4WNRxyA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
