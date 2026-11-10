{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (eol)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.34";
      hash = "sha512-U8ra1o/i+Sfb3QF30/f5MKfc7UVymmkhUd67UDxdx2cqZdMrX4mKS7ongx3mbRQmlX1YNnyUaW9IOtje/YTumw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.34";
      hash = "sha512-cJ3FuXFiVcWrGLe4rPKrj3+1XDOtT3s+nVsKCggZnBphxSee0qMjHSgzWkRIZJSYLdK6EHsaONLgpwz1SQa3bw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.34";
      hash = "sha512-QLps42KPNzKF1BPqXDJmCsUlImQbvXOs4J9ZaKJPAOGaH3Js0MCalnq213Hu93+meiiIu1GnajfDJb9EYOkBZg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.34";
      hash = "sha512-Ns8o1Q1LE2V6elJ2AdjXLb7ga6UDJb2ZJSJ5D7QagVRLSHb+15UpP2y6Pqdi0ECigu7CkP3x4Ckz4G3PRSgAQw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.34";
      hash = "sha512-muA/KqU0ABiMXlPKIqMfHmB6uev0tYVmIFEpxpaKMrW6brT9p+tlDS14i8289Mr9qHryR04Sw5c5EZp/UIDGSw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.34";
      hash = "sha512-bJLaic8GOzeRDJOQsOW1HLX+qsqiFmgkUnE9kf1tiV0wfrgwwfCFjDld1S4SNxcjmDVAPeQUKIEh1jntHsUA2A==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.34";
      hash = "sha512-Trh5NBB5dwV5OjxIiv1AHUxLCsqP4S8UGJYlbZ3ApKV+F7Fn9JsEAeJCey8G2C+i4j6XutfKaeb8ZAEpHu+SXA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.34";
      hash = "sha512-lInHviNuYNBhtrdVSl2qhL/fkr7WebqOWy345KB/0T2KBA00FDKbLLrBjFVBnDmip+9iFx0QSwpE7QWU2LQreQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.34";
        hash = "sha512-5G5h7UxwOsJ9ttIUAzCmkrnOVVWXMNrwVwWeuHU++Bm4EKQnr/hEY80ARcOueVzCkXysKkdmjkUKb+aw7ZdPtg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.34";
        hash = "sha512-JvZL2Y3uoMMzjUtTwqLG9TAgiORUMSR6gbAue/HgXyxQPLWDfKgsSqcj9TwNFdC8Fkh4RbbQToKCk/1RILDoVQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.34";
        hash = "sha512-maeFASMIS6nCfISvlfqkeCPxARSzXdeix7FTOEoybQC5fkC2RwvXpe6YHzvFBhPTZ943qg1KyLyiaZYH3i+03g==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.34";
        hash = "sha512-8gObESMPIfwpmIMzQbd2NjXpiAAQAzkGMwhp8Nsie8i2rKz/X5vMxidMWsQc7zLUPXhO+s2ULSH+R+CT45cJiQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.34";
        hash = "sha512-92NlgRRa1e+CFgwmZkKqxXq6frRgc1uDfrHmlkoZ6FgPQrxcU5duzmqrezXHiJ+Zj9dV2NcM6opcEygCGt36qQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.34";
        hash = "sha512-QQNumpwNB2Ef02LBUtHyjRlX68ViHxcAtxIOKRIxzZb5vLunQQmsN+rgCHm9BvYRzuXpJemBqIA4klyUhl2Luw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.34";
        hash = "sha512-nwwRNvdXtznNAUswh09erWC+7maTedKrE9nakWtKRJ7k933snUBNHaqIShFxves60M3nBg6r19MwL+Ae+fxQpg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.34";
        hash = "sha512-00R22Bj9OB9smFwiw9zVXt+si+p8wEPJaXy1YiblPteyGs8JKIKTEZCzxiEkmW/TR9ZdVVPjH8Z1KXjtubTOuQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.34";
        hash = "sha512-QEVZGeDu18qePA01LoRoKs8TL97i6hwyTbkqxR2fsvAc4lMrlahCTwU9CoCw3wfNN8e7mdXvOCks8dahB3Cc+g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.34";
        hash = "sha512-hVLLXBtNb+rGelRpu+kmOQ8ztDVsBb2AB6Oi6932l/+o17vsHW/Uu9EbYFkJ8vZ9VQ/VOlD9L2Zy7K+NEr5Hkw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.34";
        hash = "sha512-DRWMNt6Dbf45F7Y7SYDTIFR+TfxybbeKWtIRACHR7BEByZ5pRaPCFLVQXmwqKJHcpczkqzTcR2zT7x8P6TKsYQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.34";
        hash = "sha512-R7Ns0+QMm2Q2dH+R05Y5RpV4LPtHApmX9FKLJNX7UiP49Tlu0LI75BQ7R0oN5hFE16Ntxg3+33CChLE1qDdVew==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.34";
        hash = "sha512-tmhJzEmAamuHMmiAMZL1VLbRbw97VFBhvVVOL3h3MLGUz+Kfhm5aNi7IlypktfGMyvxbL/C7953naZfTXWVGjw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.34";
        hash = "sha512-aPlKnVitchQ2q0v4S8Euj/8kMjXgNlWxAMhWlsOkYu5uQNDW6DYdXPmeZpryCEfOMwXXltoruxpEXgLyASU4sw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.34";
        hash = "sha512-pOU94ULrO33PoxLJWbxwOuNiTkSU1ofSEJOTE4ial3pEI1OivPPJjaj40/zIejDj7F7c4roDRcX8mWZxUMJ4dw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.34";
        hash = "sha512-mTQMuAoBqx/0QvjHszXF1yAXqHbATbTu3md/DLbDKNnSUHCX+PxnilF+RB+KQSrUoDXt0mTp114k5xV4UL6w5A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.34";
        hash = "sha512-9q46VMZ+K1SpWtby1GMfsyrvSBCDSH5Jia90Owf0H8xFoDhaZTp/kolddoaCYytbySXvix9rBNjSCPRD4M4BlA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.34";
        hash = "sha512-Qwb6+mysT752bLjmwDoGXVe+AFSjF3hmpc9lIWNMVe9mlu3S6JAOYuAsNfH0ifDUZjZcodb26xKX0m9wwvq0wQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.34";
        hash = "sha512-KznJDpY/sZWxosvmD/v5sJH9keI3A6i33rhpX8pE5BJf41TpKUf2KJOUBePZ5ue0y8PjbgSFQh+5P6skV5Naaw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.34";
        hash = "sha512-tHwbFOC1mLcrdYnZF/1VXg2kMNp4xpM1UOxbUAl4lm6uDBl0mJHLVymtKuvs33XP2ofOv2Qlj0bGDWI9N+r1BA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.34";
        hash = "sha512-49nGq9gO9PHbuk43kB2B9FM6x8iLRYlKzte18wo5SCVmFcYSacsNfOEoQJ+iJuGqRoeTlZ27NMepZd6ckmZMJA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.34";
        hash = "sha512-X1HIZf01dUoXgfEkx6/RDLB/gX1Pm2BgVr3gAZvUzWbENPL58x8E3Cdl/y/vKKOkmaZLWuH/+86jwa1hnN/nJg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-Sv54qraxMA+x6MVy3bj1AIIdG1uVhvpt3RDHuU0hAcF0biB+c8eRUymeS1Hqe0XRTQh37IhjMwVsntk3db2XuA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-8R7+ADNsVuatHF3ryZcPYCuqn0t8a1NLD58P5oEfZBKdruHTUEAOrQbPz7vitmp5y6xBa7Ez3yG8IljtiV5Y6Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-LtNxyQmIkGUEKRvVUzVYQ/SdbERHaaAZBjiswJvBiQKWMmTDLeaSJ9w/Qs9hgbYFh8LaKmwUuQd6KlNORMQXTg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-xiVXKJRi8iUo03eYUlEijL5j1+3Qb8cySoDu1doElxlnqkXe5TI76j+T4+i+Q8ajRJ/aNO587VsHETqP3mRM6w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.34";
        hash = "sha512-llPDl5wkLeMpmIf2YGaFiVY5WiqlxD/9bxn6bOmqLiZ8kd/QOKxs74fOIc9jIv17WiH0VeYCgffbmr8WA84lEw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.34";
        hash = "sha512-A2103IOU1wTsQVQ8cpkjcanMGlyOh4bNGilwFjeULQUgPRLfcleJzpOsmTVy64wa6uWCzdEsWN2lJt+9n+J24w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.34";
        hash = "sha512-DtVYmb1Kj/hecIVDiaYiD6RgFwalgvTnUuoyAmhhsaL1cDgSC8K183VeJHKc1tbWeMvM2pP2Wymst7p4nJQNWw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.34";
        hash = "sha512-PkWoDH2d/hjy9tqrEMCHu0GSkBic2FiT5W7eE5E6DJwIIviwug48e+iZ2s+g2IDu774QxnO2QKJB8Ud7nbud2w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-o8HAF5s3Ejqxf+g9LvLxG1Ke8rwpwpjXVUuk4wK4HO6AcSdxqKBOGJIK50NrptIkHm59DHhlr/kP7cfq+O7iiw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-mMrzD4ft+UCafdEk425MU28081Pvuq2lTW6nPqkUd4E6I6OJX4weoo3G5yxptZcJdmti1hMzC8NYMqsVLgM3bg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-JE7bwG+U/yXL1ik4ED6m+zhcDPsBx13f6PWIbPoe49msaInlH+FF3C6pBKsYG9mGEEYxXY3pcb1wp68I5RnmFQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-w7HUws9ZetzjdT7XalwZ0l+PAOvYvrdtvGAtbWjjahhvoXsfFNgI37+3uG/RYRujrg/XsMwFU23nKILn+loZ1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.34";
        hash = "sha512-EOGbiGPKJGd/xaR5WdAG3VHQhiX61RGqbb1ZLwj7Dh9XSNJgwy1ZPTeDeMuDvgCcgTN9TbvwDYGn8bvTehz4fA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.34";
        hash = "sha512-XAJi0bPTUoDWbLQ7xhJoQo/t9DAz5TdxmJ5IEvjF22UnMORv095QZ+XWCxgaJz+FcnDmDKUjgvvLJIGmks0vdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.34";
        hash = "sha512-5KWYsmss0Mof30sjjCiNrN8tKM61+aSU0Qt+nQZ9a6W4TKymTOohO82N8vPawMoKMhEWHe32ConIwhT2EO89+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.34";
        hash = "sha512-fqB1EMzydBPvd+1yklsxA/5o/2TXlOQnjFoy1HMjYTlXT42e/8ej05/O4vHKtULM6NZiM4mj0N7/KCDoFI3CEA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-CwhTig8OKcV1idMIU8DWkp5LTIz5fyiYV4HAY4JTT4AEkgKxql30RwWFx9qDDPrhh53Ygzv2r8ueecho7/8OBQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-sKwVeVGZaib5gq6sqVNa9QpDLtSK1dA65cJiaf+993JKPGkO2x7NFVWJzZjkQQzaI4hn30K80+GXD1JwY4fKLw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-RymLTqEbdepvn2v7eXB1GS3FD4dK4YOoDhlaNcOBMJjvvYdLCrMPMNvAEOPnojCW702Bkyd5pnJ/ZqguFoLVbw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-ZErzL15ExnZP11RSIfMf9t2bTogmGmXxqu98AiqjK6GKcwHE1e8n/b1QtNwXiyiKEqagA/j+FPc+cyGLZeCUbQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.34";
        hash = "sha512-y9k+9mHjlCHYxpuYt1R5R0SHO8aB2ZSv8OK7Vx0rz300xFARBu4904RMrdknPOEBEtyancUdNSAuIRkSZEWAmQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.34";
        hash = "sha512-CxdiLm3JLFQmOwyP2xpPoLvf9V0Zk6OY9RUljhFBxXBwzQKhNq3FIq/1NzbiKpP7TB+Fw8ObTu8mIWKvfFj2qw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.34";
        hash = "sha512-8N7C5KpV+VWWSyTCezatkwZqCDmtgmbH+d8VgXF9W9lHXfGxOfaRydWzPdfHmB9tQN5MjKIXD6r+fw9mziISsQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.34";
        hash = "sha512-XS9AG7Jnk/7Gs8wfGRMFv6noJqlV+jA/YNvI+xxYltTBgsQ9wncgQxoLW8WkxZ1wKVEj3wtIzHFRn/MNby3DNA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-tr2jj7mYtfvLBzUEPwuzdChwzYiBd+TF7PcfeGCWR5J4YjfR/OtYHMdDRC0h7rk9iilEYyS9C/f2CEPbLQNqLQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-FLrgGfl4l+2+tYYFq2PzdOwPMDxlHGs+I8sMyNpEqT7F5gf/5szJP9qt9o9THwzliiPSJECLuku+tlK5+GkhwQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-RW6OvZbeakfG22e9qwj0dd6tTRevP9JT1M1VpBrdDDSNfzDShe+lDoRvBljC3uGYWN0o+qiLzPz/CWb2/PlCRg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-tEEctzEaWn0d3Xiy7Z2C9tYMAScRKBc54TTreutzfsF6WGVi59iPDrD4m8zXf54ZBliI3fOVNwTle36MXzvKKA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.34";
        hash = "sha512-aZPQNUUQRtdlGaVVY4g0kkVVjp8m8pXevpH0AkFb6K2lrsVxs3aJ73wJemom+4ZeYa0xBtVPjCHST39x5ctVsg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.34";
        hash = "sha512-ScBLfs1aW8digmP/3y7dVGdht1E92okmexSq/FiGaGZOeO/PpvDENGKdlHhetUob2tm702UI7o7fyMfABps7Tw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.34";
        hash = "sha512-9IrE1slDqcgdbX1i9L/thWuQP+yMuoF4EAOKDW4QVICW0AKPkBWAygmFM/T409V2jmFH5mJd3GsEYauVgfFxSA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-Eu0zJWR/dd+/uu508+mI0bNkjoMx//Hh22WF9anWrUposxmIUtTHQ2MQ1mS7Kwv+Qp4UMZ2CYcIrN5StbEk1oA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-Dnkl3JZQFNWxVz0uDZyhF5HxDoFDwOgIocybZq/rEZLna8z6JIh0EeFGMmQBkobrVZvh8xYWKAEVjUMcspJ20Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-k2fbsjagn0g/WIKGWoSFf32Hln54bN4XLNjgaknAgBbt6Z24siiJ6hJ0e9pY5QpqAcJ0VYNNNQB3K3kJs6NWUg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-9uIMq+YUuNq1TPyYLJ+D+yYvniJQrHDqFJiiN4shgsD3bYFkfQUdo2ryFyC7Auxjot9orMxIbyTpsfXUUuNpqA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.34";
        hash = "sha512-yxKEO9mCGpOGPF8GIuiSooWG9v+KgOo+s9mytdtLyP4qVyjnPY6wnh9B+q5Wx2JN5q7j3is/dmAU9GlUIk/dDg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.34";
        hash = "sha512-17nVFB2mr3JrrvvHLnoktGFIqNPfCvV4Xor/LYQdA142FxnR/gDibxygzfHJBj5wVqjvXxTfpmxMAPVL+TJwNQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.34";
        hash = "sha512-3HrDYVOSc/P/4gdFs3AWOMPCHzW7k145Nc8Pif+GszsSbkU7/ZGr1N4YeZ/Raex/NVvU+WZDE8IEGsG4wtTTJQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-HayD14+zSYlDWx0U/0fLzVRrMLkxtom4KmiBdW4n2iZyYcVUyormkZvkLSiFuUgcfOvCcuujdNQ3PMoD/Lm5pA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-gtbzICd6WP1dwnx9iIpqoK/jAQAFsFtuj5KDqW/CL14u9sR3R/JmQ15mOubCCMFvIbDDPaoYs/mLntQMvi53tA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-JTwfpjeAtwGcpXg2os/LX0AUowsSah4qoFPCCyScwlulT5iFLRzwJWxJON3XKr8n0/YMTzUCcRj5ryV5c/afWg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-8/HwgTlPsKQu+L71T1L41lQNIDT4nfSiz94hcdt3Y3VU6i1AV2KVpTmBsmqpBZ+QmOgaE8SY8p4UMFUNW0HvFA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.34";
        hash = "sha512-rQ0WRS/KgdbTk0/o8zly/IGZCSXkEWVuvMXH1VCMLn2ounU5PfNGD+uwIpoTUTkjZPs7IZ8J21KNYSNWLjfYRQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.34";
        hash = "sha512-rxCNI2XL+CoOUcgkZtM1Jpsw3Vn5/k+p69dK7vvHFUdgGddNyOdBwb5mJzXT8d88Pk4tO/lr0+fAP7SrZk3xNg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.34";
        hash = "sha512-FPf5y0ncSURlTDO4W2HZub669PsAedyVgZHhQnTgaQXtxUJUmZjs8/wmYoCy8TLSWA47AZ7WuxDNPpQKxLZnXg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.34";
        hash = "sha512-sIkwzozTM7sgX0uiDAubEOV2uKhe6Svf37krfofbzOvmcuMmWWO/Sc5exX6oBNV+mmtrQ3N+E08stqPRKLPd6w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-1GMoK2WyyMN2gIfHFBXVSHEEJSNw2fBcWFl+gu01Uk8xWGmSFSjDvv6iXiCIAu1/0iq+5QCcL9pqf++F3/gz8g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-F5CSGFGop/jY9DjW8oYqsgUSGa34ilatTgLl2ceOpdy81kXCzxasKOd2WIxhNm7D2tBWVc9IhDnFN5k2agxv1A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-UToPlYO7pSwPYRZ0kemExZziA4aXtrwvaUuhusj52OEK0DGeiCTMsHTxg9yfGyKUTyShXwlzy679j6bhtOl/zw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-g0058mE5Ib9nrPOyTd3X6HqnONwgJ1xW8tKTA0kaypOS6g0I7sgETbMr4/e8JEdZ/dTiltyyUTtaEH95ob/clA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.34";
        hash = "sha512-/EdEkFh8UPrv70Q5SEIUvEpMMX7wtAhXO2jNb1cDyue6cmKxVinvg8yA/gqU7Dcqay95RqidhZdMjy5skTgu/A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.34";
        hash = "sha512-CPzJXxVPR86BFvK+WbfcJA/ldygRAZNhx/DuWnwx3ziy1s7HIqihpEKkYL5ilUQZYH7FqzapvLnfkP5oEn+BeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.34";
        hash = "sha512-R5DjILTLRVjc3IkUYtCIu9pYLFLbIxqesjDNSD8s0gWFQbth2dRRV1uqVigcrImzspp5wLNuXc2gBm9iK/Z7dw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.34";
        hash = "sha512-Ix0hP3yVFnNmnKrJ/HvSlQs5bR4QDK79NFrjylSmknXCbKoe39xUJ78Hdg7ya7koJqeRbiBgz5brc+IowQpCAg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-6sfp64+xpbCEm731hoY2TSb/CClVARkcwviSHBirJQx9Q/MUPEmdug9V8t6XLjLwR32WmakShvZg+HW0ADuLHg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-RMrLWiwVq3GyDljeKoIV0sYQT8/mAuYQMoSUWFa95UZVWwmOdgDra06rj2aXnnYF24x2ZSssfQl2fAGyLRN1pQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-cgJSTZUu12FwxNd+mTBqcPSw98s0ycT0Qr31B2jAHCEqZRNoVwlxPYN2LZ140yrE4aeUsjK/U+eZsbCOs2R0Fw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-9XBpSGRapcpFzLP0dyfUpwj3gm6aBphtW0wRPs9BcxM+QYGu7kruMfb5vL2qw4kEwR4yt9OJPOdCg+FaKlCyrA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.34";
        hash = "sha512-4bByY3CEsTVMDV4exElqzpmsqE2CySE6srr339LM10ytdurBwlb6ML2NilDBzAvns+IWvjX4USlRynUpBivdAA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.34";
        hash = "sha512-Bjkn0ZQAwFisBtoBaqCpbnZFIJtLtq5lvPKFVnhfxGkTSofBFAw3Terc8t+DcO2cf72w3EBhIz//JZk5j1yPNw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.34";
        hash = "sha512-9Sx971IXZUAp6a906c810WClq1O/cTZXejMkIYbix2EjJ6NguDieY2c4ejNwfzw32Cmzo0mfxoQ0lznUOkEmsw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.34";
        hash = "sha512-cscv8gHjz2CKjXdvTLOx3Q8CiqCeDhw6Pidm93bBLN/f45KwABZPP7tcMmFXLl2ZFoP5Ky4lwtqvd+1Iwlhi2g==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-CKQPoyzqioPSc2or8/wn7FFmoqNNmLDwaW/EUsptgYLxotF4sqMmUfJne0XvwODuCQjZLeMdrZrb82ne5C2aXg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-H58QEaH79LlCAN680k+epeazRPdsGff3azwHH7lsEWQpdelQ9ksemluim8fb+JvsUkma27UgrAOIonffXrSTDg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-lsApNQyLt994SmEcKPdOj0jBmQtAa2vyuzn2FkraHEc+6XGXaT3MltkemgSQ9QrQlAf9U6mfXg24RmCm4ZI37w==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-6bHNuNLL5KPdfMmyGmi8OjqwkV9BO8vPI0OkCw3cBq5gtwh1Q4Y1YHnDWQKW0xDBcft1mcIR+Vk+pTQ8nQvEMw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.34";
        hash = "sha512-ET5RAxfgTuXDnRzCtqQ/0j7wKoz8BF1V82mNlWI8rSTNE5wAWUvCZXuASBBMQ8rtXIZUKaE+qr4D5g//1TT0IA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.34";
        hash = "sha512-LL28BkGTJlcDiyoGmG1hWlmq077vOA874a4LVmwpLVXGTwDRujrY1dRx59y6AyEtvguv9wO2uLA9o9AWyfkBBA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.34";
        hash = "sha512-2D7qUIN9TJng4jYaOuHj0WersRfDHCH4/iQuzingKe92cCaNRkXorMG6tMWQ0J5LE1EAdYbwJAnclaQ8pZWMbA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-Zim0BQdcMp3DrerFeGihSHyt9r5LJxhzPuNm1QsJWdSQJd7wTVH75eY33zdhl3qvZ9SO0XvpHN1E3H31dGONxQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-OwzOaWpk6hqP9ZJtwdSni/7cxzOw4DVAM3TkaoIIyIcG8o4ydLMSAcaTiEQbg7eC/6jg83zZSWqMsZBEFKzF1Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-IMezO3T0LCgjQpOrD60Ql0U4VkmHXL0did0RlH3+zv77tTquQrZZ1Iu7vcDW0mUYLazBHtHlxuhKvAvRyITBzQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-6lZtDGVeKOaO8QpjU559BpGX4cCOXM1TU2w5XHr9GexCwhVjlRvDZl2u2PrvmLn3bAUtykluFFeWAgxRpNlubA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.34";
        hash = "sha512-BTpiaSq8pUUpbG5zP0XJOAUyqCD596FrCcqiwSanyyHSTFU5aGc4Z1br0lCQoTmDlsJQES0TfXcpU7/q83e1Jg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.34";
        hash = "sha512-NdHRXZmVCpc0GH77vCMGXBAole57emdCM5zeIXXjg2PBnpf/1Hug3/Dq600eYS9fgtDWw0Qe7bEBo3Lfbz3wrw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.34";
        hash = "sha512-t0F6bXGyvavGjrHq/aWuIKBrokM+Q6SfSMTEW2uoGVDyimohZ32iq3aP/WkxXm6gHfJsUJeTDSAwO1QARdoZ4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.34";
        hash = "sha512-XhwstYYPWyfUz9rAtTWm0wlysgy7HqLdV7GrEovpfUNWIB30Fmoet/EeBANFX/kkDOmDbVj0ONfcunaI9iD+gQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.34";
        hash = "sha512-dm4Z+RSygh2pzbBnUc0lOipAXFlevUo18fI3peewaew39B4HbpX/1MKr+9ubp3bkK1qI6Ra06oZZegTYsljAwA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.34";
        hash = "sha512-baQlxAxxJI/SiDr/G+h1+9hr5BmveAPrE8NcEnwwIIz+NsWnEqCelVMbO+yT8EvDgxuAvLOTNvelzkN/3BqyIw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.34";
        hash = "sha512-ZhWXiXzA/CMwnrKYHG2wdGUDXsg5ehHTSJOSzjIF4LTpwC7u1Gq5jsiv64DnrWC0lvlxAADPW8Sq0tkxzzkCQA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.34";
        hash = "sha512-5+TYkfs39yrIA3lJknvMoQ9FQF9YXupZ7OTGQJTigeNcwPAqQuvtRYz/RnmnXTtEN1lPVD6UkAU2qw/PD9R3gw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.34";
        hash = "sha512-Ai5PcK93I/fh519b8T08rDViKWEUuE5uJBXq3jNi9idbZ9NGGAuD0rb0jExkkPSq94miukyFd7sRLdJ7AXUUuQ==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.34";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.34";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.34/aspnetcore-runtime-8.0.34-linux-arm.tar.gz";
        hash = "sha512-nbDas111g0VNAGz7m/cvldfsYBqTASxI1gBU+3PT0tJ3BEVgKIbJPpgC6ED2hlPRDuJNiHhXe4oO9eE6hTOJQA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.34/aspnetcore-runtime-8.0.34-linux-arm64.tar.gz";
        hash = "sha512-NHwL8eXB5QDBWn5Fvd0velSuoZZbCq4Yel8PIUg+Nl2Nyt0cYWaRa8yIVh71moCLCeDA6MqJTm+UbfC6Zo+5Lg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.34/aspnetcore-runtime-8.0.34-linux-x64.tar.gz";
        hash = "sha512-7PWxTYp+wyo2YvEx50xA+QA1NOmLJMaCwHwNaPZT0I+x1nybNJfv3T0nkBecvtqfyAsfiHNpZEEXGdlP6tqVMw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.34/aspnetcore-runtime-8.0.34-linux-musl-arm.tar.gz";
        hash = "sha512-B16IzJ8+XAVkpUa+gC0fwv41LxjDYKoaVRg/uhZE3/m+hCum5+sdH+X+I03o1FCpbf4hQx6UOWcm1ZFIQdPKSA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.34/aspnetcore-runtime-8.0.34-linux-musl-arm64.tar.gz";
        hash = "sha512-plK0xW8iI6bqkMhxbNxEbrHZZpZOddwWkPs8wiQDgUlZdd4QeyKuipsosQ4R1YfH9zThCT2aUjhoQXXUC//mGQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.34/aspnetcore-runtime-8.0.34-linux-musl-x64.tar.gz";
        hash = "sha512-2Lg/GNi70de9YvLbotQ/Bs/MujUbh1p2VGQ8HleqO0u6KXyCTlJFFgRXisMiMB10pwZSjy0uGVhs99FnXjPAog==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.34/aspnetcore-runtime-8.0.34-osx-arm64.tar.gz";
        hash = "sha512-EADCbJvmVeEkZ4Vp5TmCyEF1lJyvc9o1FLI+1f05/o/QZn1AEkxlC2uXaYwmS9NMhFAFX3NPuigPD7lDtBc6CQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.34/aspnetcore-runtime-8.0.34-osx-x64.tar.gz";
        hash = "sha512-L31uD6b7sdLbeAip2YQ02vCJ/sZUbObd6ox8udrOwVkWRpzzNSE/JOyQYqYcXUM2HUngIGMf1eHjIS2N74D6pg==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.34";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.34/dotnet-runtime-8.0.34-linux-arm.tar.gz";
        hash = "sha512-FEFOCJyg2Jub2et2Os3rVK0N2potT8QkgR3EYdI4CWnwjVbAFIdzlW3xQygSq+n8BdoepYKIfrzdKLrNPs7BGg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.34/dotnet-runtime-8.0.34-linux-arm64.tar.gz";
        hash = "sha512-Vah6rwmEgbxzCCQipru+oPeWNHB2z7dMiZJoXLddmh0zQxPJsBPXJohghsIr4RojRZbtxD7LtQV/WFBCrLxiHQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.34/dotnet-runtime-8.0.34-linux-x64.tar.gz";
        hash = "sha512-OUnFM7BLDyuO1/allUCYBoV4kd4H7KX/J5XD/+zFw3PIl3ziluoRJM7wiQ+K/rM2Wju4UU0RqRunmttcR8J92w==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.34/dotnet-runtime-8.0.34-linux-musl-arm.tar.gz";
        hash = "sha512-ekeimeHORmFH4rFrAM2jJrKJ/ULpeBx1Aj5E7XpCF9DdrFHoSQd4sDZkRkUarFmZCC9o6VeWfTAECxIDEWkHBA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.34/dotnet-runtime-8.0.34-linux-musl-arm64.tar.gz";
        hash = "sha512-x5LhCSxKSkhXp5dELzmAmCzieKcb7KRu4uU6J5QWZ3pI6sFClyZAgdk3NkKisODOfRtfOkyME0h/b6e+Sflbpw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.34/dotnet-runtime-8.0.34-linux-musl-x64.tar.gz";
        hash = "sha512-iXX3BYUEr4gAF0t/S5ZPM2t/g3I3/oER+YMDicLtG3azAd9kQ7Xm5VEq9trGEc+gh69wu3KvB39s0aE+vNoyuQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.34/dotnet-runtime-8.0.34-osx-arm64.tar.gz";
        hash = "sha512-fw7vVUTar8bnZ0+GsqxSkfWfGgYOVUDHS+X3/o52ZUKX6BZObNyY4Memu3bZV3V47FRSZnB3UVOA5dRdkhTZ0Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.34/dotnet-runtime-8.0.34-osx-x64.tar.gz";
        hash = "sha512-CVcvXzeitp+duqGgG6o3DudMasNTykUb3g/deVxAwAgSZqmZBjbQfcUYAhonL/CXsIeN+p2opuxOSSdKnu5axA==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.428";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.428/dotnet-sdk-8.0.428-linux-arm.tar.gz";
        hash = "sha512-i45PyN1Zrao/jAh8XUCsLgy/XYw7iPGRDyAyrluu2pa6D9X6PRdUPyH33siCqmzcOKfV9Iy0tBEHdEisCl/cnA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.428/dotnet-sdk-8.0.428-linux-arm64.tar.gz";
        hash = "sha512-vMEAkeQEuq7AHVOL6L1xJaM6gzhZSmp5WxA2EorOdHpFDT8UgvFiELan7pN7kRSIZ2EJFW7CyQXOMQMLrbGw8g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.428/dotnet-sdk-8.0.428-linux-x64.tar.gz";
        hash = "sha512-MyEruZor8AOXPUEQbH6P6UIIoSlY/2AdSkdr43lAPIWn3JGDpuxk37RN7XECllvgnzWt0XWOaOklG654kde3vw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.428/dotnet-sdk-8.0.428-linux-musl-arm.tar.gz";
        hash = "sha512-y2dShRhbb5M/4Z1RygvxO0Y965+Rq9Vpr8W2vQimicDjwmJnhW8H0y+hoICBO4ja6M+gUlV/ToOaobM/fUMF8w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.428/dotnet-sdk-8.0.428-linux-musl-arm64.tar.gz";
        hash = "sha512-7MzXkMW4X5DGZBhL1AaIUd/FsrbsAmbQOaph/rNug2n7G2buXBE++iw1vlSvBWYbl1RZWySSA+q17jtGIjmO3Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.428/dotnet-sdk-8.0.428-linux-musl-x64.tar.gz";
        hash = "sha512-s0IxS87ArhkD8ISP7IMmSiif6mCJuWZGxHgL4/aY+mNDucOOd6SWm8K95sek5dUIDMY1PETW/XWGtvZMF0hZVg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.428/dotnet-sdk-8.0.428-osx-arm64.tar.gz";
        hash = "sha512-wpMM5jY0FxZRQuVhCZLfFDCxz5P0tawxAn2mEaa8CJpz5wYu7QIAvj5KMtuJOpLIb8J4FqU1IeWwQar7oKoSFQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.428/dotnet-sdk-8.0.428-osx-x64.tar.gz";
        hash = "sha512-Jzv8ofW1AZ1NvsR9zjVD6+glUQk04vuG9UM8oy4GkKgkJh0eVhqdMUC4+AYEjcGigMl5BY3gqWbBrMZyq/fAuw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.134";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.134/dotnet-sdk-8.0.134-linux-arm.tar.gz";
        hash = "sha512-jtYEQfAaL+CHvDkPVnKzZ0C6ZvVCuHii6FkJ0XzFX2zJraM60mRL9+3dmmlX+v5svBekzapVWMz9aLSOfdzEzw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.134/dotnet-sdk-8.0.134-linux-arm64.tar.gz";
        hash = "sha512-olmNvWsgfqrti7H0pUbz9AUoVga6IwHG7nW53aCOB4m+5Rogo7uU2H96bhkefgtJMlid9NbJFwlIWTKnW/n6Zg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.134/dotnet-sdk-8.0.134-linux-x64.tar.gz";
        hash = "sha512-p+EFgRI6j8eb+oB/IM3exKsdGQsffuZNxpDQNYzTUV0zRi5U4Qm1ufVfb7t10WpU0B19NdJUZfl3ZbhsSNeXlg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.134/dotnet-sdk-8.0.134-linux-musl-arm.tar.gz";
        hash = "sha512-Irmgv4BLXUIoIg+lYhgK9NoBGMVc46fH42466tJ/3cxeaV7LGETMCcBctETcm40gORXrV2xU/6kJOkZE5QUdkg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.134/dotnet-sdk-8.0.134-linux-musl-arm64.tar.gz";
        hash = "sha512-nQppeTmGeMIG6s4OPYkGSeFXgzTsJohfjyv9vx8Xsil0AD0mvVUmhNsD5OmW29W7NYGovpNAwcWK62trfXf/3g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.134/dotnet-sdk-8.0.134-linux-musl-x64.tar.gz";
        hash = "sha512-j+NL63RJ3lpflcYm6Hbf0mCYKYWCl2ZqoL+NINExgKHbDjXbY6FpotK9QB/ezIdNlVNmBBIZRLnUXzQQDksvWg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.134/dotnet-sdk-8.0.134-osx-arm64.tar.gz";
        hash = "sha512-zaH3/YbqDet2vHw2+alaXXb63j12E45P7FfdkS0xriNlgM4yr9eombjSgQBbKrFQ/y+EKXlCA3KoqcmjS6GUqA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.134/dotnet-sdk-8.0.134-osx-x64.tar.gz";
        hash = "sha512-N5UoOU2iBteDK3vvHyJgN98MNM5hLzcFymA/cu+fbguyvj9ZrUJr/ntO1ZjBInPIbizorxD++9lwKdp7g0v3eA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
