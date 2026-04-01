{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "11.0.0-preview.2.26159.112";
      hash = "sha512-huMDRnm5nJ/S/jWobiEOWQLjbEaTZmEPMPNJWhGP/P0IAPDcZYOs5SIchHmXGNLbPKRAk47KylkcKY2pP3GCeg==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0-preview.2.26159.112";
      hash = "sha512-7c8bFP5vyR9ag3d5WvG2BkKVIxv3RLGZw9wIP+2iAfSw5jeqdMkm+DaccUljD4glwlqwy0fAwTWroM1xIpDaew==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0-preview.2.26159.112";
      hash = "sha512-XhWkw44QMtAz6NagHgqC6EgqpUM+DLYb8iOI4EveCYHjvMqq6UjTaQrvmxEx16NLzxhK+czol36MpuRESifWPw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0-preview.2.26159.112";
      hash = "sha512-3yjgdt4oUhTwsw1QK94DXw14nWs5VX7h1VJN0Ist9I1AdIxbsdJPz4rOmSze28RHJzJr8Cc8A9TFkgm0onLhPw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0-preview.2.26159.112";
      hash = "sha512-XHUntvl/OYKMnNJJhZPaHO5f7B70KQfZWS4QOMVYGuyHKaVnHLnGvDmtG3bd4lOlicT/QnYROvM/jvtrYSKePg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-preview.2.26159.112";
      hash = "sha512-rgCZ7LzZJ6S5UqYaX7riQCKNPF+fU3zFadktsbXdL4X1FU53oC/z9UF7TZ9aFsUc9nW+i+VRVb9guNwVkQg66g==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-oJ0MjvVYdvL1J5UaQTXkhTywKfF62mEE3khb++NlR+Ti9mkW4Ph6BQaKPPLst6R2aplUD0dzQVdWMHp31CI5rQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-+i+I8rLHjf9vCIEv+J3ptyNHp+X9QfTG8hvfaNXfFaSXa80pEdyzNarrP4Eicn0XZPnyv3I8T/L19BrIo65C/w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-+SGlGq7e/WzKfN7OdSRlvOcweY4udRF6uB4Z4SZgKbe7/JrwK6WFxWftXzsIpPev66r+cy+tlUIQAAr8BglG9A==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-4B3QTp2NUx5uYG0vBoQkZFiAyjz5BYNKy0jNowqo/S7lktpeqst2jyMqWDIpe85yxtk9V8MHY1j7gboIGgkNGA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-+OFha1Da1H7RtqHx+HT9G0/K4C9r3nwfCKwe/S0nla1nDJDE8mMng5AB6s062LwThDB7fwE9kYhBFDCPyGWUew==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-tpDIY2QzkrZR5ybw41RU5y5ri2LE4LmcVmET1dPzAN96Anf/M/PxKOnQlbtFi9zyT3RJ77QHJySAhDmnbQXdaQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-CnL0bt13RtUgCDR20aci96hbPVP/ajK2lpR1xB2sGZMK86F4biOKkg9dYlJrV5kB1dyS//0sb++pitMSJ/XqXg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-SvO9gn6Pr/AUi+Dgnwir0lTjqQF3nSYOJvZT6+73rlMQnjjJDZ6tqJUz8NTMQ6jcGOCkgg9GmXGj4inOZj5cPg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-FVg7LNTQuZxrZWl5gUQN8y7TIlgB0OpYaCOoKY1fCjj9wfkeIBCFm74N5lmqEQ7RmWTCmxz85jjDlXriAEV8MQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-wKaGO9CBim+oDtWSu7mVW/dHwnwfvIOMR7aIc7dV00Iw4LSTWgp5NDxARm4opdBztXnpRrVc68vskjuB26JhYQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-22MDz/J6FbP4LuyjFt1hj1dDUj5eL2IqfGT0xHJGBgVDO998HuT29xKjhnR5JUZoSQNm3qZTr1Xsu2DTDL7zKA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-IldXtW2PJnypdOHoZ79peqXofcWkOELTn8nVGkgIB9Ko9CVIrlL2LxfN23tj7C29eCiI6uIcB+oE83R238ZN2Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-O901DiASXuos8Teng45UIaFcf6Rlq9xwYI3b8ILQDOdumvg4fhlMVlwjyl8Mq/wmh86aRVfrjHQ89zsmOgDZVg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-6sAjDis8xAhZarNmit2swh31yfuNEhsTOVG45gJxLAc2TOxZBmbqxY871tTzByrUEGheERfWWGoqwb7ef1744Q==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-sMVN2aiRJV6d+2gGjgCXlNeSlxa4jcLB2yGRsBIhHAHDxJI/uDpw+yLeQ5O1hlscoNsoyxtnhvw0QGdKKGRJKQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-t7cHEI+3T7WJ5IEoqQ6Z8jcGi1xnv7v0kuXxR1I2Z0SbnSw6xVQn0VnqW+dvxrOmu4FJwhvo34KJQXujvtvwSA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-vuCjw4dKdoI18n31rOkYdyg0LEBZjSwiLEBAjK9q8WftcrKMKMJvc1TLWhV0R2sJ5021Gy/4MfvaXKUg2bxjew==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-q27p8zmXlwwFuG605hM1ZZ5VEdTrX/QTv0615XXeAIXnTKRmF6dihqu4JcQkPZX91Okry1uNzSJdoiqQaYjz5Q==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-ITgE0XOKmCoZ1XFVcMEN8ZXDQV1D1M6vPIo604X6GeAWIBHyIYYXxKCgeidXJBSO/xtkif7xSjD0DqnT61uvGA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-STOb6DjOIWFAFlRJS9cW8jbUMKGq7P8IeXPoz57q5LaqkQA6PHfQIB2tLXAZHijllAWsb906ptQccHEtXDibWA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-CjB70OVZuu+eAfhBFyNjoJWlmzs5hFmlvhIkYhSzgJdpwUxHcEMQ4G0rK8ptxgoqK5PNfzfbReW9wJAr1aR6SA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-wT94AIXRS9yPTo4CAifPC0hWA6OlXGLg+/NzqmR+BI5TCZhAvZj2DqIB/d1BOx/QKG2IQN8HsipkFeCkCuLiWQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-YV4nGIWZMhxnHeLWThzSE5cYxXeaPIAHAaCcJ5BCeMow3gvGFVeS9lqwE4qH32eRg6v2KD8BowOLoXigEFZfkw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-BIvFcyEbJC0krhzXm6Miv4eOjLwPF1LTOQJnViL4aYbnL1Sb3AL5T0LPwMOipVGFaqFS6key5d3/zY0h/9SRnA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-4QQY7MgTj8dxb1PzJDg+XqYZlsJ3ET9sxZKCfxgTj+0iMRW1LMho5ol/6ISU0gR09hi9wOzEtyD6BxOIJ/fy/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-8SHDCQaubbCqkQBu/IGOGO0EioExH0EWrNxqT9nOwllv/S8QiEPkCEyrAUmwvio/GTrDDXONE3Mv/yo6OujtYQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-+IwWh5LBDeky4XFFiwlwxlrO9tchrjSajlGMMZ4lup0qsVxjlYKVCCDSXlvXa2nGq3YQ3Jcg/CHO3rDxP2re2Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-kAAYo82FPKLBHhrFYXk0W3J4T7m5q3IdjjynONU/5Dx/cYBGDQf3fgAqxCIhxuzJSwpooz4Uluz34H88KrKZPg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-Tix4EphjirBuhKwFy4xrDxPY2drSP5snSYwFwvqjXgPkjOmLay3HmHqIyhh6X9iTzhnFztHncQcAnZC0F8EbgQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-WbRBX3iBvW2nO0w/JKCWaQLmxm94IB0fKEG3N90D003OFSkoiVyUprzf5ndJUub8mk2AmCyzdyRcu8QP1CEZBg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-NpJ79EM7TeDEYrga7GmY2191Z2bGKzdc00rWiJJXsDb/+U8XsGFWhlaHbakAzxEKY1vjp1RW1XwQQVC/tJ+rgA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-jqqbeegI6e/clyKJZGMA7eK/p6zoeY0fMoR1xzS9lUzlsoGfRN3Us/36+ODphS7qvCnAye0EK3r7mJMwz3a51A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-RbLpiHF5iu8KQ3WL7hhcWYPI6FuEMx+RtdMv9lUiFUe2WlH4w550uRXwilh2INyIsnO0aJAj/2sBqH8Ooq0ZvA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-y7FZ9TuntiI27Mup+r+b4U2nNeY4zoJstR3MPhxCV2+6L9PHhMDCmRJpsCH30PDU/TjpjCNcBUNXqB5LI++Y6Q==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-uFuOTR3CA2DqBo24TQgdidCrBxTjJrV3jkOevCx6y97ulgPiJ5PdpnyKfW4T7UZTfPWqFSJ8AVI86AeCAZYLAQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-UsKuwwmPeC6bIyasZlKsmgJTZMO/N6wIjvRISjnSDJpY+QeIc7JyfPjQpjyPvy1eJUGdKA0mYu8xEjwsYNUz1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-HRY0iAXnJMlIZmFxSaA/+yk6HxlAg2MqWzofNVmTqlyEsewcXZNnfYMngbP3Sqj/q4bbi9qMUd3Lqey42j8L2g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-n2sRo5ibogvvVAQBJV8Y9pGVMH2H0Nch9DM17/JExbKmkYyuHA/fLI3OPp/XjAxEfBaHFed6IMeyQbgwbdg4Lg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-v6/0PMwaHByQj+5zsZOXIOZmu3yN9I5vuX6l/kBKt3ZD+ELPB01nXh6fGQDuu9c+UA5JK0qpYJ79gC1jtKw2tQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-iwWTxB6OCL8VH4b5WgtHIU5ok3XtcUdMwcMGafIqplagsKF5qyvRM2ou3/Y8tNG6lhKsjELEtLG6RCXz5BbZTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-n9+WISKnj9AOOEPx/9bnElTGRm9b9vnEhuK06QmNRYOa0VUbqxvckSaqhR8pQEwKeSKpyRa3h3Q8dxSk1RbF/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-H6S+8aL6sH3vzY44J5uStKr2f5moWwdTjr3AmxNIxBI+BR7JZsZxiP3S0o1lh/pSOZA2bV/oCB9BBAAedM+D4A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-58ciGUUVX9dm9U3VdY4dJ2Am3izraTJv8hstek5rEUo3Ua2PG7vWITSaKEq3t/hC0+DBTYMfSQKqyfbZxp5V7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-PhyE76rTaJ6ttSad6f3zu/0y808Wh8DxyTNTltaGWhUDqCqy9yBK8ZtLfk6A01QLgBe8+YocVPxpxJ44pDX4tA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-JzGpur1THflv96GqFQQSUs+DS3Ze6Hb9nb3am6Vym+aPF8kJF/SeWiya8nrUd59VmEjJ8p+ONSG0xUxYlKid3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-sfgywv51tNrmaVkFOOLaNn2ULPN9Z+la05MYCgSZ4vvHPAB4QbbPyzT7lOGhsUqTvj7yxEqJDTt9pmWGRaDN+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-gdghbPbSTPY4P76ZYu1Vypd/TmZj9RSxSlfBSHQpkrfOGGlQKTBcuKcGQ1Z/j91SR5BNqdnKrpAhC4qrQZmt5A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-wYm3ZF/1S7IeApz7bFVWzozQmLou2RjvdN45W5ik028NMwWR/IkW8QGD7sy9Jul6XIMjVkVsVTeahqGzTR5GaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-nHnlqV6np0cAYgNGMzC5nzGWDiWFdCAqvz32JYqreolY4vCAOvQ8xff+jz5SkEiU6ZWH0L3u0g8iito8JEBtzA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-36Yk6hBnMhh/UgfvlSyZsv0BlH1G4vJ51Zr00z8TmL2a/oAxiMOv6Vco6FQ6kxwvTN3OxrXkTxFkYRfL50Qo+A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-Kvr3Zr01O6RL/JkKFU7rqXs6n3wOM9eMpylMOPBXn0dtD+3qhMMvQ6BDAT5pXCYGb0DH24GkuzJASci56MptfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-rP4QYwnSwpN/wF8bI6MNirI6G1x/C4418Gh5WO/8XGxwSkh3sRi7DbpyLCMWNENv5kOnG++glIKxZe0v9tIXfg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-WW267wMfS5k8t/ZvPb87JyhjkqEVN7/ypdbfvTSNEqrSMMb/aZCQl5afKrK1euE6PKhU8T5OzJTU1IwwclFlxQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-AId33/8H3nZ45tSx8TMPR0fEdir0Fwaaat5IlhAQZx3tV7j7Bx3IyBx8f/QMHg728KmjDUvG2G0GqchcBWv7TQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-F0gDq0gp2ZhKtjrDZrtWjq8S70d+pR694xZ4b7MuFjRE8JeTE8yJZg6rqkzcolN6JgpFwDeZg5NqiEWPjnYTqg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-ypd1CGMFEGTL6ZKUR0U77JV5Ll1fNVvqcHsTsyGFknYdlU/DuEqDqdstzEo+jAYyxYQNUL31bf9ODYAr2IRSJA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-DxRfMf3lMhKkGDYuLHw8aNBiwrxHwJzgfIghPyPmvvSHsgvdcV5unmH4ppVfwxPtRajAx9/pUBfxe34wha2J5w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-eccHLsMada4DWk9dICUma8FlNeiMTucXqLn2t8a8PExKCtp4jNPif9vqaerwLcaisjjs34C05XjJH6xsIHGPzQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-Xeu2lfRTlS3w1/u24UR8O/ZsWzsDZ0X5dJZ6lW7J/XL+hnnXssBsy1sQ4bUJnoZZ7vWIyp/N+52f8JuYU2snwg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-p+b1gLJc5abhNYKKwH9MA2qbcLl4kFd9DQJdbmZIvlrqBCUz8ujFJAH1GvdMQu7iVJM41tHLe70Cw5S+3QkxdA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-hD1h+RkF+BHu+7nRaRdej4E9oysYnyFdOhC4hXd+TH9iyn/utsKI1UdrpV/c6kmnxDZuwMCT7ux7a9hLkATfCg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-1t2z19/7MDSHEuoUATg7ecNeHdZVPK9vhVcaSW1AmoDfl6830/EjhsYhkGPSm70Jd0xhV3yBt+XycXtEIm2Gyw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-L5oiLy++mwUN63tdFkGq6phP349pL3qRgNhxEKunRlGmHbi/QdQRr3soLr71ubjjY3IITODKlsSP3D50UgMk4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-OASqlVye352dX5Gvo/zD8WV/hpbbSau3ETaWQ/tJrRP17zJ4SW1I6ZkOYyVFgVwt8QBCSxLtlpcHvXSdQxQgdw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-DUzCPoejeJ/TpgNhsUPxTzUkYRSWSSqnQMEXgNOSHnS0K9d2lusDfA4UMVLMalSq30UXHX4dGHRL1uz6UZfFWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-SbK3G7i/cqdZAlj4MDzJgyb4kTpzkwOwazli81/BC8EYl9RgchZzhezjxnWa5O1+tmGzKzv8JNSGHhkWCgeUVA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-klCf2EMVBztt/Ql7EmVRRt90A7kqFTuWhlCbYm62kBBrJSTWd/k2gJ0IrUu2qlKh+aFmCpRWVD5f7wFZgocRCw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-+cKbbT7qx3sw/HCkvf1tnJzG+/+7eS2a9AAzslKSzqUKxHv/mBbKMXN1Tp21nTr25uVrtI7J7PoSRfgpJir1LA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-Zc7wVvUxjgzcr0zVoqSJV3hZp9Y0UUtubZnTL+9XS8eB0IUh8D4JoiKe3CUaNjCr/fBBpUPFaBJgb5fmLK2A4A==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-YEoYA0ZHDIiZhfEICQTcfT8yvLRGrOwiUSrogFg2Dwyo6a1/BMmgRTDyAqQklFt35skwRxJ4QXhzASE0xtHE0A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-4Z51pLSqUNZcERSIe9kjhsOfirF+EWnlU8G/ngnWo7V2qSQeHn57B78fP4RHlwOnt91W/EawemUmc5eTsPepwQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-j35h+F1GaU0bPwpebB3aoSpJxWCZNNJMkblNWljIausKdaiOVD44DNlr1NNtnBuSVBsaEK9qQSq4dsvGj+ijwg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-qV0iUC5nPbwhtXB60qXxjs2upe4mHkUKBZdMEifdZA3iscoeXjKcv+1fzpeHPk1SGynylpUF1TvgzAv7ckdpjA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0-preview.2.26159.112";
        hash = "sha512-KvlvZbO2wE8U+C0mPLefYUzhADsMcSqZA+NJQqEACiSgnWNvYwL6UFK9H9E8Mj6DpTT4YYO1cpp6tSAuopLHwA==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.2";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.2.26159.112";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.2.26159.112/aspnetcore-runtime-11.0.0-preview.2.26159.112-linux-arm.tar.gz";
        hash = "sha512-2UQCwesKKRCWe1sfNY+9WlC0bnAehsGoOQy6+ey9nwFmPDGFVCogcMnHTdAaagK+Vn79TTGTIfbasIyOvzsv5g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.2.26159.112/aspnetcore-runtime-11.0.0-preview.2.26159.112-linux-arm64.tar.gz";
        hash = "sha512-cRkUtyUwyLa6SeUHeUKJOlK/VQjMCCsJrgT1xyrkoJ3Xhpn/ytFt0lov5D1YZTP4l9zbXIKrKYL/a0rW/f5aWA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.2.26159.112/aspnetcore-runtime-11.0.0-preview.2.26159.112-linux-x64.tar.gz";
        hash = "sha512-TAL7tmvEtzieD0PA6pajBGlU6zx60Gvw+NkJl8LmA90KOSnispueiTPMdjQfteYuvlvLg9mjFBm90RlZBP9a9g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.2.26159.112/aspnetcore-runtime-11.0.0-preview.2.26159.112-linux-musl-arm.tar.gz";
        hash = "sha512-7tgNb/StksyBpJ7ImiAgmehnZSWSWtBNQB560jEEPbVUWuQo8VciBnnwfB9p/9BJO5XmEq0kKn1vubrui7wJxg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.2.26159.112/aspnetcore-runtime-11.0.0-preview.2.26159.112-linux-musl-arm64.tar.gz";
        hash = "sha512-s71TT4AwEUjpLSs84jPiAGmh2IAgbm/u80Jly5dz/o7end+L9V9KrheJdhYf85RgsuF/EsrYn4rwYkicMODAVA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.2.26159.112/aspnetcore-runtime-11.0.0-preview.2.26159.112-linux-musl-x64.tar.gz";
        hash = "sha512-3lscIP5mGlqTZoS7E4qLqB8pHdHLGa0MjGZByf+iEwFKaKZiZVJYuU/EgvovULtmbGSUZZ0Nr7pZhzyeZoEN8w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.2.26159.112/aspnetcore-runtime-11.0.0-preview.2.26159.112-osx-arm64.tar.gz";
        hash = "sha512-tOYlRs61K2MDgsV3VG7i6PN2zYL/CFnQ/278qzDoCLPZse+yU4JJ368GvN2WCTy6Yn+T0oFlR0NuzvL70v9XTQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.2.26159.112/aspnetcore-runtime-11.0.0-preview.2.26159.112-osx-x64.tar.gz";
        hash = "sha512-S9BQ35rjksOLar9yB2K933+sV6tO99A/JWyKzooCGIhuEL7X9gj7k5j/FY7fejE98W+1vp4J7FaV7vooNo5pow==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.2.26159.112";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.2.26159.112/dotnet-runtime-11.0.0-preview.2.26159.112-linux-arm.tar.gz";
        hash = "sha512-ij4BdH/X4fzDUfQXu5hhXgJk6O0al7gF/Do+XLbd3uVbRZXOxX9lpAZOMISenZrXkRbCwrqlg1ubwGP5jn5H/g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.2.26159.112/dotnet-runtime-11.0.0-preview.2.26159.112-linux-arm64.tar.gz";
        hash = "sha512-Q2MP7djKf9wwKxa5pkjUwG7x0mJzmMymU8YElEhXwgBQIls48KHFoxbZvucPNQfygAfJplANt0cPFWvLpY2EEw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.2.26159.112/dotnet-runtime-11.0.0-preview.2.26159.112-linux-x64.tar.gz";
        hash = "sha512-Eea/4bsW4qNaxoKuFZfhVAqPt/xwbsQk+j8Lvl1l2ofHDEOr8Bu0PSQX4zWTCurrTWUyGfvIN5GgSdLwUMF4pQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.2.26159.112/dotnet-runtime-11.0.0-preview.2.26159.112-linux-musl-arm.tar.gz";
        hash = "sha512-m5kCD18Zruc8vKEDAFhVmwVKoM0rf0Ug6i36prJyW29WggyK5iFwksMUbsS0uqCx9UlSQekEioc6SGJTvyIaeg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.2.26159.112/dotnet-runtime-11.0.0-preview.2.26159.112-linux-musl-arm64.tar.gz";
        hash = "sha512-UJtMlIsdnxhpYDBQ5E354o9jbUCWwArlLQbjZCM3E+eOzx/TX5mUmGgaq4tBpZxEppLMhLT5JZquOs+Y2qmR6w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.2.26159.112/dotnet-runtime-11.0.0-preview.2.26159.112-linux-musl-x64.tar.gz";
        hash = "sha512-h8xgI7H/isT2X9i8rpgjSTL/PbuwV5HBzxlQ/10lw7/uNeTIvfaLIbaZrMJvy7Xf8NyETCOwp5HFlj5C84w/Rw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.2.26159.112/dotnet-runtime-11.0.0-preview.2.26159.112-osx-arm64.tar.gz";
        hash = "sha512-4dZ2ysnuf1g3IQR7y+FT6QPvSnN06KQaHy4l/lw3zLmT2mGkMAuNXYY5bEZL1eyQ/+E2ZITDLD76ZvW8QWaHag==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.2.26159.112/dotnet-runtime-11.0.0-preview.2.26159.112-osx-x64.tar.gz";
        hash = "sha512-XtTdaTqEjjmdlgUqH0JbRtSRUp+qfEuw14KhFRCc/d/uXwi9GoCD4nsNCzU0RSj5jyTHK5X5gOQxxFsMFtxIIA==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.2.26159.112";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.2.26159.112/dotnet-sdk-11.0.100-preview.2.26159.112-linux-arm.tar.gz";
        hash = "sha512-hELI1SnQnQVMAAHXrSW+qMwLMwydzc9mF6k1l4Ai0f/SwuHCOcbtYgoL50/MEltHKudKgFn+GplpSGuXvjr+1g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.2.26159.112/dotnet-sdk-11.0.100-preview.2.26159.112-linux-arm64.tar.gz";
        hash = "sha512-cjUUeiGXmpaaXpBH0oSh6/XWHglJcX0X+d3BWQXlx3J627rxRA/aLGx1Z5Y46YAGUs095tNVC//HDlXyBXHAhA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.2.26159.112/dotnet-sdk-11.0.100-preview.2.26159.112-linux-x64.tar.gz";
        hash = "sha512-VBikP+TwuxXc1NlwEfZLmuRz4ZD91GQyrQ57kTMaFigwGkD35b+z42TwpC4icpsFl7ZvtF1GydSheRfOoJCEzQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.2.26159.112/dotnet-sdk-11.0.100-preview.2.26159.112-linux-musl-arm.tar.gz";
        hash = "sha512-4YYk+QGnDxy8QqnaHJp3Noqjm6GSuME3EvwLD0TGSODZmVVuUgkZoIlhJdU0AfjmOXtcIth0IA30nBtbL9Cj0Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.2.26159.112/dotnet-sdk-11.0.100-preview.2.26159.112-linux-musl-arm64.tar.gz";
        hash = "sha512-O5mir43aRP4GdXASH4hBlK8kIXMwbmMWnWvuPrJGOPU2MR1/mZIObQW3eFWkW7MiGXroh26jPRWRSC88Vn9ARA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.2.26159.112/dotnet-sdk-11.0.100-preview.2.26159.112-linux-musl-x64.tar.gz";
        hash = "sha512-PgZ4P84LpXbi3BRLaJB7kyLA0KS9XlEdLSChL6pR4UXmtJ0VrPEiQft8pjSpUR41ytbRfWQpM9TGDcFZIAcseQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.2.26159.112/dotnet-sdk-11.0.100-preview.2.26159.112-osx-arm64.tar.gz";
        hash = "sha512-4u4JNbHMV1c8qgXZ82mM2wmKuJSxBWvgpjqtVH2F1dzPt+NhBOmQid/Yhc8hsiduvFFm7V2poyEoB7HdMPz4OQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.2.26159.112/dotnet-sdk-11.0.100-preview.2.26159.112-osx-x64.tar.gz";
        hash = "sha512-tjlQ2aMR3U0IJ0xX9MK7xIqnBVhdbDZQmScVyMGQ5zZOaDLmU54js4lhPJfYVf3PKcJBMzfRG+S2KYZcnafUBA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk_11_0 = sdk_11_0_1xx;
}
