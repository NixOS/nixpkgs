{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.0-preview.7.25380.108";
      hash = "sha512-ZedqhbGvDx8Ajn1N9SRKq4q/m7rIQdPmcvQS7WOaijpqqjNa4P4zTd1kx+/kb6a5FJ6thD6yt/hEADTGpUpflg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0-preview.7.25380.108";
      hash = "sha512-OcQqR5UG3AFa0aQNIRTB3acRpQ+OhuF8ZpLIQM3xp+egvzzKRP20jja/gWhngIVtEA012XxLiNxJrHhzWhtLhQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0-preview.7.25380.108";
      hash = "sha512-1UT2fr9kFvdpRb3+h3dTmGTnhKTvGKpYFRQuZUD8ukmaQ9ABhnXp35E8GJoA6d6pOERiRnhimzrVg/X3B4znUA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0-preview.7.25380.108";
      hash = "sha512-Eekoq6ATo+jeIsK0GafnGK8XkdjKtdOVT7deD1TWo04/nt0KV7nOmBUOhwUKY1sBsjvTQvOoDthn505f74N3Vg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0-preview.7.25380.108";
      hash = "sha512-pX4P7NG1jHIRJrbHrVP/MvDyA89o7HeuKucToiIH6flQ5ixTntZJupIW5qg2wsScJOltfP3A7j/w6MTRA9dHOQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-ekrR6F7cC48jWc0+Fyv3emOc5bkuv+yvKg2ZDjuv9gRf6e8zWGG6PkXKkPuo8sxHacPucgc1bIibVgVGJi20VA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-QUg7nZopW/0+Lnk4VeNHF3Ov3I6IuqsDSbvkeEDWjWyNXyOnJzDErKN3d5p6jWdmc3jjndyOw1137vaOKV5apA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-k9W3fq0DjcbjxuveOQd1ou8fsHhNH/zHayPE9b1VRj2CijLx8krGGKkP3gUR7jLbOE+o9/Xln7cEsWzRBb9tdg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-+zsgGnlZS6MdL/uyvAQAN0KAc8Vk1qT8ylHCi+iwUXqwslSGtZQku+qGvkd7hjMMnEbnSa5j7xJY4PNGDbco4Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-+LG/u+Jp6b3Oyud1QYP3nph1uqtx4rhPbeH65leIMSFQg6bB8Jd9g4hNwESllHd6iKpKP7Sp17VxLKynzxwHDw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-BE7hZwP4oZ5Xacmhjwc3Ciy0KJKOXwg9NJiBVzFv7xEJ7IqVceP7kAdMPsMNoojwz2KNs9gJdCOGOLtwyeTZyw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-oskWoBpDhGI4WBOJPFTBIirjUdSs7hvHKGuz8OQmrByyv8C3rY9jtt+sM45uqINoGNyYsgbUQkQlKFhIB+mT+Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-+/apDtwjBvmEn40DJ4yPOYqCsgIfhrD/zPYY15A6ny5kN1n6uV8LgUce9vv2HatRsD4uOuepD2z22/TbB8GjLA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-+uZHCjs+FlbFU2StjeANC3vvYjWd+6PlhIX0F8sHS60u3U9/HEi4JECQ0vhak5ODJCi+wktEKZQ53DwGAvPbJQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-mtm6VWoDGYg7qlqF6sFlf8LBEbGOL6ZCSoqzZ7hmDBy9UIe0AswL0d+AhsDOE5ewHifbK+vGqXeK83ZdL/1IRA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-/X/ugPn9DMhWz26lDvuSlBqX/s56B7Sl/Qkd2/Jy5iYw64+9tOFo0Xh4kz0fF5nOj1H9RbKxIaNfPVc41rxvIQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-/SiUD5N7pwkJ4mK83CBkre6oOB76BTJ7lJUTDDw3t8F6HUJS+3i6Cx9sODd7BS7TXXA5ahql2gcfohVsaFsR9Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-WKqXIohGOzMUpDOsAEpknxj93fSuTzSdP7X/Ud19dggmqwPKMIWN5NZpWlBLdyP8+NMwLyNM/aR4uCtNf7MT2A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-GQokK1ugeF0JQi0IfkyNDm5nIVCKpH6V8zSskBRSAH8O5U4iVImpDkqBg1icxUFIAaVyiMi6GJB0CkTD2cC+yQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-X15A3yBhigC8T81Ut1Zqqay9HzfCjjwLh1QDbHL2XggIWiGzkDf4hSX7qnkbki12DdFZP5p0xDFiYsnEBTGNgg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-vNMheP+ysMxIiINElw4ebu7O8KHDz+l2dYTlP9zfBllo7eJW3XX0k7kOP0nYke78KFhheXu2JUHAAEZVhazOUA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-478qsicUIxQcpq/UGGoNNLRbUldl34RRZqxDdRl1HqC2D4aUdCpR3MEU5vd0zcbHxkegfPfgQgsv6xfIt+k/Ww==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-fDGfrQnqXasfMLIUs2xVvLNxWjN0w7HypZ22wYG0y8PkN8u3vpVIQz9tYgUgEXvxKpFLYq1L2EcxksY6reAWug==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-WE52ljXg7k8/ry1wBJ7lqrKniEZgwpMtuf7m82tMtuc30k5X+1nAbOa2evezPgjsXrB3k78uertzT+GoSRX/fQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-TY4LXwPBf9d0vOpzCkV8Ze9e/Tnn4V07FkSctLB6Vc6XreNkVqEQcB1TuUQZOFc7pXBvpImRAD5mAfuLVNohDA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-UBWg0zDyYiiy3wXtxmRqaoAvi2hpXGGJ4VxoKcqgD927ftcYXz80g5dFDtk8zof3CVnfXHgaDCm40jxOrYU3qw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-ZHAexbNsU0DMvR9vVqYldw9m+wyqLM5AVZyx6E6Lgk5JzjgDI9rFfDI2h+UGi1WOJyKPDKrjyLWG5phtGC6ytg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-HmKdrzhgbW4ikm6lKWgaBm5OokH7aPyGuaniMHvRKnHSeUxDYMj2PU/ZSIlIxTntxELeTBd+ZcJlknJqR7Duuw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-bPfmwsqmA39Vfa+Uu9mH1eaCJZo/qd+/O0aOYRhjSrypYBQK2AIif8lq7zYxhOR2U5AhvkkeqLNnaEC3spTHiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-OSpFCcAHBwfDK4bY6zNDfbtY+fKY6koEgvfVyk6OtdUI+dOM/Jjw9Kyxiqe1S8JC5dm3366+AFdqF2ZWbMW4fw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-gFoRuWxJUSjqz8meGfPQhK/xI8LXK0/z2mOiVWfwFBO1lMuPUWFrzlUvoPBHhZSYj7578iHtUog8r/tnnK6+Bw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-BLvup3LOAkOw5G/xJ0j9pcTNNQuPLibW0u5bTVAmMYYZny8b39xNWWVqNQ8Rl5jewPko/8luoany0SbHZ+GUpQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-2NeuUX5T7ZRuc76byZXf7cLXYTK5fGufEbrjEXRlBMXyI+vQ8x+6BR+hbqef9JGylT8pcLv+xL11Gx39vk2KmQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-iZO21GJ4K+PjcH9Gn/OUVQrBkkfCVCifO+PsQItVuWuenEOwAShzCfz8E5icd/INLIosoriCyRV777jpjxHZXg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-SAKw8xQa/VBWOumG7JmId0UIKUs2RM8tnl3KPXJ85mjnrrP3wJLWynNf6v/hMxdxqjAOIb2Y6AIGwK4zFzA97g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-PTVNAmlIQRHnMCcw8Pm5+t8eLLtwyZ1J6lUjTcZ68dU9FGXIySRr750lekvMpBugMjmXIsNw0VQvg9AnL5SIDQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-VbIqcklAsQYAAV5CTXo/6NAa6lkirCeh1XF7Yo2D6xZmkwLbQsKfNF1jpiwYr6luiVwJCkIA6p/owsPAZT42gA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-H5a0wdzBU4tWXtTkYcgHsezWolqD59sDLSlDdOGE/OF7p3X1AijCo1BKCb/ub+Qn24dXoS7RGQf4TwmPP/fDdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-DpKE33FA9NYJXAY5SbKcIfAvU5RyH30YqhCXxHi/NYfEcR6e5hrzn4992S6TpUQzeYHeJHprfXEQGK+x8bWTqg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-prERCrIwyGg735ahEDi15HwriaDnwZlQidlFkiDSOuh4EJTXLqbYvwJxSygCNIgKAivNEwt5HuqAR0WxIzxLJA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-gI8nk0A8LtN/NXufax5tgmoxnAFvG9SUA+yGfBz82HlAvwZkWeQsNjZav06LsIdBgY+34oJqPfhGFWki234b3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-6deTINJifUd+6BioAPScqa94hbH35wweO3UazZ0Dob4GFoSxD/z7jUjRIib/HmyhXz+F/QMOZapPNN+qNsmEPg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-T93T3DT3SakSQcwaB9SFTT6R38hEh0/52bM+4IqvFAo1EAKx3eXiKezE3bMSjOGKHxKzb71Rp1d9Jflv6capLQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-dnHqxZvkLe4SubfrXiPhb08qkj2FOrdCBWLHo/Hd+pSop3C86rCTRJY454LrPwjnktjnQf/X0b4anadwOkckrg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-8r/yMsXff3vlFUaRzlHKnkd/qxmbo6FzATU4d065j8YTNZcduF/uKiOKijwXSd96nj216RjCUIJWrcH72c5H6Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-D6qubx3bzbfdDMJw1CcUJdPR2w2oHmOt/ur4q4Pi8cdFueROux3u2bcuurKmx2eZvHhYVKnL1njTxWDVHUM1OA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-neXYzUGCn4zBhHa4+9NgG6c0ulwsfGczrrH2hqJcwf16fNtBgfe9L+JnwRctrVVe7iOci/qYh69c36OlCsREug==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-D8SDjyznO8H+3w5eAuL1pl+JZ+4S8eXM8gIMuNaDXvBZv43lU2by27Gk+Ue4eH5zV+462fBtBvqZtaETgfPsgQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-vk6trHjpJkCveABOceuodbxeAefojPqaUCGwU6HXinNgu281I/iEF7Afj6mJBLHxaPcvlFQjAjbRhll1SwcSNw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-r1LB1Ilq1/Pf71SubpoHU53s5bjfHY/TLQUhG2R3AGFMe1S2J6H35pkXuCdwBH+x99AX4khX1zw00BCYP5liVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-ovDMqhvYv4o6P/AjvAh26EcSs6auYHe4YBgWF7SBLgB/r1xOvjlRZRuVL7znu/js0CwTH7h8w/YvW+q1+Tzw/A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-K7jCpNm0lYr/dHheLoaPadsd9q8oQ0X+iK/rJkeKrZ76FLzAvcC1FqX9yXICwAW44m63bXcmg0ggra1+yXx0/Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-R7g8lya69aqDY/iAIIoX8TnbxEJxBIxvuqD0zrcEuJgRh33b2xys9OAT2NmyZH3GWdTZ5UPiolJ2SifKNE1ztQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-tPbKNB5TVRIAHyts6RMV2AP7pnmO/1MRtfTByCqTkTjH945dJ8+2r4ytMIoQ3ooVLi00yll9w2tDL+XnuNT3xw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-W18K405wGThiTnn12Mi0K6KXznjPZX87mX9APiq+nbKIsMmGC+r7cyIPgy9hmggnTb3qqv1p/0PACRD6NXm0CQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-K7fKG8YuufAgq6VcvotJH/D4uHmcjg/X9TwWq8EmbyysqyNCuMkg6a1torpyaomdooKSZ0LSOodqbo57B6jERg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-alvGXGuLfWb35dOybu83zGbH9VyIJRf17FEhF6yrNGvg8gJ3SwpU/N2uGnuxI1TIb8dFlKq3FoE2hqfxWAERKA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-8345qvf7b3Q8hoqXErpJTWQeLmBV3GFUNa/hp8eCglnY5WWbnfd/muQAdA5zUoOX/8fMA4TILhZx2K0M8k1/mw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-um95x3i3Jdyat4T6HTXP9I0STmsqJyuTWmZwCg/5EPNWMX1fm/OIFIoUQ9lX2kplPyq6Ys0hmiBaVcHOHGThgw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-LneCr0cNCIEYVfDI2Ab++j+baaKut+pqTsCb3R9FAp9pqYVXveSEXn8V4xx+N0i//SQx4i9Dkd+oYGERun9k2A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-xr4GBhH7aIMfPXjv+CuGZI3h1PZc+yETwn3/9UMOXXNxgM1zrkCR1p4I8rQNpwVPd440P8pReq2AWrdbLX7kTQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-slvRNr3ZPyyGLrOFEPVF91TD6BJcC7/UKrowVg0XGq37IxTeicrNLhs7PE8qmVGBgUTiKcqxEU7DXI2/qBh9nA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-1JBZRsQMZ4mCN0rS+F6wwP7s7+es+uwx6hG9ubUuccJYjCEAWwDg3vBVAbQqwMOF9rdbqOLFbkbvawOT7BHAaw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-8fiTrOmlVMojv2oFxSO4zKP0Mz+3HazxfqBFBbgioN+/dMNiCa6ql3Sm0kp88Qmfcb68PwhWCJLy3x3XHLEUuA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-t0G1lpmSy3Bb/0k4riHo+oT2h53IbHHC92oy3Mnxg2Nm/ZBoGDW55/maB5lF+IbEoNsScpAhsFNf7gAv5KPOhw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-Xgu9wAHojyPC6/9OhNk4Bpmhmb4FAcJMMb3S7xwwPFuEx7pKSCPOA/3Gv/8xR3w3lYoMhvs94Jn4zzLPw/d46A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-FDFqh+DYEYnPZjLzODbygevvyrQH15WVg/pcDbiFlE0dsoL7LQ3ST3G6Vz5GfpAZyO0A8O7ekGOH81+wskmeiw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.7.25380.108";
        hash = "sha512-npZ0pXzs+1mOb/G8asxE4QYUrrQlvuVjO24sgaqgQ/o8Ir3m1jTxXhETRj7IXKiPiVMIaLPV+c3XtpdDKouH9A==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.0-preview.7";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0-preview.7.25380.108";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.7.25380.108/aspnetcore-runtime-10.0.0-preview.7.25380.108-linux-arm.tar.gz";
        hash = "sha512-lXwjay3tSsk2fperQsxjo28PeydYBQA552QN/aOCTlpl6/LTB2L8diIqgdGUpJ593riZcUo3vCjbZwjY1bGC7Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.7.25380.108/aspnetcore-runtime-10.0.0-preview.7.25380.108-linux-arm64.tar.gz";
        hash = "sha512-gTWO1Grf/RpOLglePSPWfR0ommxMUKsg4ecRYbKCPIxE3VpsJBrJs/zUoq9Rjb/7zNt7Os0HpCr5/yTF/WLGow==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.7.25380.108/aspnetcore-runtime-10.0.0-preview.7.25380.108-linux-x64.tar.gz";
        hash = "sha512-9onzhvf6Vrm1O9fVEKvs8rnCI1j7KTZ4RsI/u6ewphpH2G287vlrc6corwduVcNGg4SXQC4M2AuGldncHqPCuQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.7.25380.108/aspnetcore-runtime-10.0.0-preview.7.25380.108-linux-musl-arm.tar.gz";
        hash = "sha512-uJ0bnKWphyzzZ3dKLKUVKkLtht7MGMWTsQSINGPOXPrKamn5F0SaArTSXqQVj4IqNqwNZVxTjBhOR611EYbs2w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.7.25380.108/aspnetcore-runtime-10.0.0-preview.7.25380.108-linux-musl-arm64.tar.gz";
        hash = "sha512-cAY0HJWlGRCm7gLVgemkHXZGSn777QrXedDmT8DXfEK70jNTf1fXb28P2zh/biVZK6UzYmcKXm7+1ho3TkIc7A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.7.25380.108/aspnetcore-runtime-10.0.0-preview.7.25380.108-linux-musl-x64.tar.gz";
        hash = "sha512-wRf0SCHNbFWna7nr/HRlYG04rInIEO4iSys6D/T1q/Ld27sZVoOeZyrrpPlR3wtax/GTXSqQttTc3cEep8M7UQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.7.25380.108/aspnetcore-runtime-10.0.0-preview.7.25380.108-osx-arm64.tar.gz";
        hash = "sha512-D5iye4E6etLrWkCOe9sf/97fheARsEmF6QCV3ikW2qTDQhSsPPmgZvSbPn7gnVbXP56aGFjHHv+JAMxBRf0yVQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.7.25380.108/aspnetcore-runtime-10.0.0-preview.7.25380.108-osx-x64.tar.gz";
        hash = "sha512-FQLipaTYahQwhA2TGknRX/07ZEZeV9IdcURItxlpz7zmU4LvgoJg8Wlt1GxAnzwD9riuenLlFWe0RMoQuoreoA==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.0-preview.7.25380.108";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.7.25380.108/dotnet-runtime-10.0.0-preview.7.25380.108-linux-arm.tar.gz";
        hash = "sha512-oyaRhovGFTGjL6O78RNBZGrFFBasUvaACTxXfTO2ODBqJqCjJ5poaoZUPg8v3MoOegfzYIF5UpRdybRt4pyXCQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.7.25380.108/dotnet-runtime-10.0.0-preview.7.25380.108-linux-arm64.tar.gz";
        hash = "sha512-tTAequEUCb2/MZg7xpk39w3RezVe84D0yrMX6SHl1mFiZCzVfRmhT7ug78CadjNcbl8u6ZimDErHYssXJR04QA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.7.25380.108/dotnet-runtime-10.0.0-preview.7.25380.108-linux-x64.tar.gz";
        hash = "sha512-EnSHIJyzxKOUhHzO1aFduMW2bJOGboi0pweJ6iyQtB4pk+ANkZLUupiPM928iaXKL+TxmmEdftitjD4KRpLFAQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.7.25380.108/dotnet-runtime-10.0.0-preview.7.25380.108-linux-musl-arm.tar.gz";
        hash = "sha512-aCCXjXxzep/7Pj9IGsDDAm3FRsH0JzlqgwkCdTiwhu+QEHHiKiCJt3ivXlG8aJpEFCAs79lgkc0zAVtQ9+GtHA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.7.25380.108/dotnet-runtime-10.0.0-preview.7.25380.108-linux-musl-arm64.tar.gz";
        hash = "sha512-xJAlZHKLkx0jIHojHNSUZCKvqtFQjpGMISfcgjbc/yqVNXQQ4vC61bLYcZxkFMIJLQk4DDrnAVG1kgoyuzOHzw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.7.25380.108/dotnet-runtime-10.0.0-preview.7.25380.108-linux-musl-x64.tar.gz";
        hash = "sha512-wCfUh5zikKE4NaJWtYraqu2hdvCYgsej42+w4ik7Qo7/U+YhpHj+xF2SjxeL3VLn9KK03p4C0gSUxLmSXMtkBg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.7.25380.108/dotnet-runtime-10.0.0-preview.7.25380.108-osx-arm64.tar.gz";
        hash = "sha512-72B+c82XraPNoxoMvqVWzWBAmiYSqUEnJxub+SXhLfhM97MmsLXt3s07rON/1vpwENSHzdxcIyR0Xe2W+LymAA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.7.25380.108/dotnet-runtime-10.0.0-preview.7.25380.108-osx-x64.tar.gz";
        hash = "sha512-4kBn/dR8b/jTCNNnNwK6FD/a3VC0pRca8qq36AYz7uGeZqC2lAvqSq6Yik05EVWjW6eOV3YM3d2lr169M1s9EA==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.100-preview.7.25380.108";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.7.25380.108/dotnet-sdk-10.0.100-preview.7.25380.108-linux-arm.tar.gz";
        hash = "sha512-knm/wwbPU/3AJnPGjrwGgYsm+wXukE/zFej/UoqNWLU0KoZkIjOkpnIi9Qe2ARC4IYSSx7l5cb7nj7EKFfiu6A==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.7.25380.108/dotnet-sdk-10.0.100-preview.7.25380.108-linux-arm64.tar.gz";
        hash = "sha512-qBiJz0LOz2FqdoXKsXUIaUzug+dqlhnGTomvr/TTgmaOpMft/etEU6DBPfzurIZuo9D+BfPfEkY4pMpYtP2nJQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.7.25380.108/dotnet-sdk-10.0.100-preview.7.25380.108-linux-x64.tar.gz";
        hash = "sha512-KNA8LaQR6BYb+jcUjzX/Yi6qI0GtzXKae1I/dKoh6Pf2UBnaENKG1nhY0Z/2AII4C4dDbfm8zicUe0/bIShvsg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.7.25380.108/dotnet-sdk-10.0.100-preview.7.25380.108-linux-musl-arm.tar.gz";
        hash = "sha512-D65/QdZ5g5I0GWMqoc+JW9K+0oaBLcysWLUkrgxrgBuxhVUJ1t9L+EfkxAx5ll31z2BrwH8iV49JzAo+/1dEjQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.7.25380.108/dotnet-sdk-10.0.100-preview.7.25380.108-linux-musl-arm64.tar.gz";
        hash = "sha512-zIjcxU2QbdIS9MOD3gfTSUfMS2RZJAtfwTqei25dfUgrymc1cXixQZUFfviDx+YOT/2ArvSEyYqXOYf+SZPBow==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.7.25380.108/dotnet-sdk-10.0.100-preview.7.25380.108-linux-musl-x64.tar.gz";
        hash = "sha512-hcpucoRlWBlxrzWL7dJkDADJ11xJysH6mz3plrQKE+lfNbdXPe+u/r38Z0xHjotXn4GhAwvj8WC2cgsx/f1ooQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.7.25380.108/dotnet-sdk-10.0.100-preview.7.25380.108-osx-arm64.tar.gz";
        hash = "sha512-eI/e7V31AEm8/hNwBZzfp0M5CkLZv1LHRVY+qsRL9UqVSqyjVjZLq2tbEIsbbZ4NbPJ8JT0uYrBkQARmn4GXxw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.7.25380.108/dotnet-sdk-10.0.100-preview.7.25380.108-osx-x64.tar.gz";
        hash = "sha512-/Dk0clsJJHMl7hDlaBlhZyKmMPSBS7k8Q7YLLtvTLuI83esARdZACAi4QNBQ7Q3Etbz5WpDeG5MpNrYjVuHqVQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
